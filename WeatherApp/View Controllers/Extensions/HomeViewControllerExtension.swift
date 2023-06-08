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
    
    func requestWeatherForLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let currentLocation = self?.currentLocation else { return }
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            self?.viewModel?.fetchDataAndNotify(lat: lat, long: long) { success in
                if success {
                    self?.cityLabel.text = self?.viewModel?.cityName
                    self?.tempLabel.text = String(self?.viewModel?.weatherResponse?.current.temp ?? 0.0)
                    self?.shortDescriptionLabel.text = self?.viewModel?.weatherResponse?.current.weather[0].description.rawValue
                    self?.highTempLabel.text = String(self?.viewModel?.weatherResponse?.daily[0].temp.max ?? 0.0)
                    self?.lowTempLabel.text = String(self?.viewModel?.weatherResponse?.daily[0].temp.min ?? 0.0)
                    self?.longDescriptionLabel.text = "\(self?.viewModel?.weatherResponse?.daily[0].summary ?? "")."
                    self?.weatherTableView.reloadData()
                }
                else {
                    print("Error fetching weather for location")
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weatherResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let models = viewModel?.weatherResponse?.daily else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func configureTableView() {
        weatherTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
//        weatherTableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
//        weatherTableView.showsVerticalScrollIndicator = false
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
