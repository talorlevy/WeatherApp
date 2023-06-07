//
//  Constants.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/7/23.
//

import Foundation

struct Constants {
    
    static func generateWeatherApiUrl(lat: Double, long: Double) -> String {
       return "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=6af3f24188f3759e19188165184e3d7c"
    }
}
