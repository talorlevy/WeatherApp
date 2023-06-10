//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(url: URL, completion: @escaping(Result<T, Error>) -> ()) {
        DispatchQueue.global().async {
            AF.request(url).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
