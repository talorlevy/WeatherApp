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
        hourlyStackView.layer.cornerRadius = 10.0
        hourlyStackView.layer.masksToBounds = true
    }
    
    func requestWeatherForLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let currentLocation = self?.currentLocation else { return }
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            self?.viewModel?.fetchDataAndNotify(lat: lat, long: long) { success in
                if success {
                    self?.cityLabel.text = self?.viewModel?.cityName
                    self?.tempLabel.text = String(Constants.kelvinToFahrenheit(kelvin: self?.viewModel?.weatherResponse?.current.temp ?? 0.0)) + "°"
                    self?.shortDescriptionLabel.text = self?.viewModel?.weatherResponse?.current.weather[0].description.rawValue
                    self?.highTempLabel.text = "H:" + String(Constants.kelvinToFahrenheit(kelvin: self?.viewModel?.weatherResponse?.daily[0].temp.max ?? 0.0)) + "°"
                    self?.lowTempLabel.text = "L:" + String(Constants.kelvinToFahrenheit(kelvin: self?.viewModel?.weatherResponse?.daily[0].temp.min ?? 0.0)) + "°"
                    self?.longDescriptionLabel.text = "\(self?.viewModel?.weatherResponse?.daily[0].summary ?? "")."
                    self?.hourlyCollectionView.reloadData()
                    self?.dailyTableView.reloadData()
                }
                else {
                    print("Error fetching weather for location")
                }
            }
        }
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewFlowLayout

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.weatherResponse?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let hourlyArray = viewModel?.weatherResponse?.hourly else { return UICollectionViewCell() }
        let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: hourlyArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 55
        let cellHeight: CGFloat = 80
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func configureHourlyCollectionView() {
        hourlyCollectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)

    }
}



// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.weatherResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dailyArray = viewModel?.weatherResponse?.daily else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
        cell.configure(with: dailyArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func configureDailyTableView() {
        dailyTableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
        dailyTableView.layer.cornerRadius = 10.0
        dailyTableView.layer.masksToBounds = true
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
