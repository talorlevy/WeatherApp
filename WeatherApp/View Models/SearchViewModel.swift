//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/11/23.
//

import Foundation

class SearchViewModel {

    var locationList: [Location] = []
    
    func addLocation(name: String) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let location = Location(context: context)
//        location.name = name
//        location.creationTime = Date()
        locationList.append(location)
        CoreDataManager.shared.addLocation(location: location)
    }
    
    func deleteLocation(location: Location) {
        CoreDataManager.shared.deleteLocation(location: location)
        if let index = locationList.firstIndex(of: location) {
            locationList.remove(at: index)
        }
    }
    
    func updateLocation(location: Location, name: String, creationTime: Date) {
//        CoreDataManager.shared.updateLocation(location: location, name: name)
//        if let index = locationList.firstIndex(where: { $0.creationTime == creationTime }) {
//            locationList[index].name = name
//        }
    }
    
}
