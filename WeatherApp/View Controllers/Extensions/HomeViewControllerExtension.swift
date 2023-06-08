//
//  HomeViewControllerExtension.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import CoreLocation
import UIKit

extension HomeViewController {
    
    func initViewModel() {
        viewModel = HomeViewModel()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    func requestWeatherForLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let currentLocation = self?.currentLocation else { return }
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            self?.viewModel?.fetchWeatherData(lat: lat, long: long) { result in
                switch result {
                case .success():
                    self?.weatherTableView.reloadData()
                    self?.weatherTableView.tableHeaderView = self?.createTableHeader()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 cell that is a collectiontableviewcell
        if section == 0 {
            return 1
        }
        
        return viewModel?.models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let hourlyModels = viewModel?.hourlyModels else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        } else {
            guard let models = viewModel?.models else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: models[indexPath.row])
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func configureTableView() {
        weatherTableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        weatherTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        weatherTableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        weatherTableView.showsVerticalScrollIndicator = false
    }
}


// MARK: - Core Location

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
