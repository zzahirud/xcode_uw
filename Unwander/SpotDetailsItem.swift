//
//  SpotDetailsItem.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/13/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation

struct SpotDetailsItem {
    let name: String
    let address: String?
    let website: String?
    let spotID: String?
    let unwanderPlanID: String
    let phone_no: String?
    let foursquare_venue_id: String?
    let place_id: String?
    let pics_url: [String]?
    let geometry: GeometryItem?
    let displayPic: Data?
    let latitude: Double?
    let longitude: Double?

    
}

struct GeometryItem {
    let location : LocationItem
    let viewport: ViewportItem
}

struct LocationItem {
    let latitude: String
    let lng: String
    
}

struct ViewportItem {
    let east: Double
    let west: Double
    let north: Double
    let south: Double
}
