//
//  GPlace.Model.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit
import CoreData
import MapKit

extension GPlace {

    convenience init(context: NSManagedObjectContext,
                     name: String, lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let entityDescription = NSEntityDescription.entity(forEntityName: GPlace.className,
                                                           in: context)!
        self.init(entity: entityDescription,
                  insertInto: context)
        self.name = name
        self.lat = lat
        self.lng = lng
    }

    class func parseFromData(data: Data, completion: @escaping (([GPlace]) -> Void)) {
        var places = [GPlace]()

        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data,
                                                                 options: .mutableContainers) as? NSDictionary,
                let results = jsonResult["results"] as? [[String: Any]] {
                let context = CDHelper.shared.persistentContainer.viewContext

                context.perform {

                    for result in results {

                        if let name = result["name"] as? String {
                            //                        var coordinate: CLLocationCoordinate2D

                            if let geometry = result["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary,
                                    let lat = location["lat"] as? CLLocationDegrees,
                                    let long = location["lng"] as? CLLocationDegrees {

                                    let place = GPlace(context: context,
                                                       name: name, lat: lat, lng: long)
                                    places.append(place)
                                    //                                coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                    //                                var placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
                                    //                                mapItem.name = name
                                    //                                mapItems.append(mapItem)
                                }
                            }
                        }
                    }
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        print("Unresolved error saving context: \(nserror), \(nserror.userInfo)")
                    }
                    completion(places)
                }
            }

        } catch {
            completion([])
            print("Error parsing plcases data: \(error)")
        }
    }
}
