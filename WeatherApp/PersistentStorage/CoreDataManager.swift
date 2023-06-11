//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/11/23.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocationsModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Persistent container failure: \(error)")
            }
        })
        return container
    }()
    
    func fetchLocationsFromCoreData() -> ([Location]) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error
                fatalError("Save context failure: \(error)")
            }
        }
    }
    
    func addLocation(location: Location) {
        let context = persistentContainer.viewContext
        CoreDataManager.shared.saveContext(context: context)
    }
    
    func deleteLocation(location: Location) {
        persistentContainer.viewContext.delete(location)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed: \(error)")
        }
    }
    
    func updateLocation(location: Location, property: String) {
        let context = persistentContainer.viewContext
//        location.property = update
        saveContext(context: context)
    }
    
}
