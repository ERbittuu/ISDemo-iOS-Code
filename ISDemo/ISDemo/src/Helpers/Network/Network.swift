//
//  Network.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/27/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import Foundation

class Network {

    // Create URL: URL devided into two parts beacause of Line Length Violation of swiftlint
    var gplaceURL: URL? {
        let googleurl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        let query = "?location=35.689487,139.691711&radius=15000&type=restaurant&keyword=cruise"
        let token = "&key=AIzaSyBmhFhb-ARwCVKzGKd__keN_3mAXKNm_ls"
        let urlString = googleurl + query + token
        return URL(string: urlString)
    }

    static let shared = Network()
    private init() {}

    // Fetch or get places
    func getPlaces(completion: @escaping (([GPlace]) -> Void)) {
        let storedPlaces = CDHelper.shared.storedPlaces()
        if !storedPlaces.isEmpty {
            completion(storedPlaces)
            return
        }

        if let url = gplaceURL {
            do {
                let placesData = try Data(contentsOf: url)
                GPlace.parseFromData(data: placesData) { (places) in
                    completion(places)
                }
            } catch {
                print("Error parsing plcases data: \(error)")
            }
        } else {
            completion([])
        }
    }
}
