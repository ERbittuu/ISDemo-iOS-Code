//
//  GPlace.CoreData.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit
import CoreData

class CDHelper {

    static let shared = CDHelper()
    private init() {}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GPlaceDataBase")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Fetch or get places
    func storedPlaces() -> [GPlace] {

        var locations  = [GPlace]() // Where Locations = your NSManaged Class
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: GPlace.className)

        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            if let list = results as? [GPlace] {
                locations.append(contentsOf: list)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
        return locations
    }
}
