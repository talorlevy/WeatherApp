//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import Foundation

class HomeViewModel {
    
    var models: [Daily] = []
    var currentWeather: Current?
    var hourlyModels: [Current] = []
    
    func fetchWeatherData(lat: Double,
                          long: Double,
                          completion: @escaping(Result<Void, Error>)->()) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let url = URL(string: Constants.generateWeatherApiUrl(lat: lat, long: long)) else {
                return
            }
            NetworkManager.shared.fetchData(url: url) { (result: Result<WeatherResponse, Error>) in
                switch result {
                case .success(let weatherResponse):
                    self?.models = weatherResponse.daily
                    self?.currentWeather = weatherResponse.current
                    self?.hourlyModels = weatherResponse.hourly
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
