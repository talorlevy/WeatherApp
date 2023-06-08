//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import CoreLocation
import Foundation

class HomeViewModel {
    
    var weatherResponse: WeatherResponse?
    var cityName: String = ""
    var maxTemp: Double?
    var minTemp: Double?
    
    func fetchDataAndNotify(lat: Double,
                            long: Double,
                            completion: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var isCancelled = false
        
        dispatchGroup.enter()
        fetchWeatherResponse(lat: lat, long: long) { result in
            switch result {
            case .success:
                dispatchGroup.leave()
            case .failure(let error):
                print("Weather data fetch error: \(error)")
                isCancelled = true
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        fetchCityName(lat: lat, long: long) { result in
            switch result {
            case .success():
                dispatchGroup.leave()
            case .failure(let error):
                print("City name fetch error: \(error)")
                isCancelled = true
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if isCancelled == false {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func fetchWeatherResponse(lat: Double,
                          long: Double,
                          completion: @escaping(Result<Void, Error>)->()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let url = URL(string: Constants.generateWeatherApiUrl(lat: lat, long: long)) else {
                return
            }
            NetworkManager.shared.fetchData(url: url) { (result: Result<WeatherResponse, Error>) in
                switch result {
                case .success(let weatherResponse):
                    self?.weatherResponse = weatherResponse
                    self?.collectMaxMinTemperatures()
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchCityName(lat: Double,
                       long: Double,
                       completion: @escaping (Result<Void,Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let placemark = placemarks?.first {
                    if let cityName = placemark.locality {
                        self?.cityName = cityName
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func collectMaxMinTemperatures() {
        guard let weatherResponse = weatherResponse else { return }
        
        if let maxTemperature = weatherResponse.daily.max(by: { $0.temp.max < $1.temp.max }) {
            let highestTemperature = String(maxTemperature.temp.max)
            self.maxTemp = Double(highestTemperature)
        }
        
        if let minTemperature = weatherResponse.daily.min(by: { $0.temp.max < $1.temp.max }) {
            let lowestTemperature = String(minTemperature.temp.min)
            self.minTemp = Double(lowestTemperature)
        }
    }
}
