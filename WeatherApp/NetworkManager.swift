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
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>)->()) {
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch (let error) {
                    completion(.failure(error))
                }
            }.resume()

        }
    }
}
