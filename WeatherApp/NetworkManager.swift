//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(completion: @escaping(Result<T, Error>)->()) {
        
    }
}
