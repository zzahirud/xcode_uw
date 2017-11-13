//
//  ResponseMapper.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/9/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}


func parseGetPlans(_ obj: Data) -> [Plan]{
    
    var plansArray = [Plan]()
    
    //plans from both invited , owner and member
    
    let parsedData = try? JSONSerialization.jsonObject(with: obj) as! [String:Any]
    let plans = parsedData?["plans"] as! [String:[Any]]
    //  print(plans["owner"])
    
    /*
     let all_plans = plans["owner"] + plans["member"]
    */

    for currentPlan in plans["owner"]!{

        let currentplan = (currentPlan as! [String:Any])
        
        let currentplan_unwanderPlanID = currentplan["_id"]!
        let currentplan_title = currentplan["title"]! as? String
        let currentplan_numCards: Int =  (currentplan["cards"] as AnyObject).count 
        let currentplan_stage = currentplan["stage"]! as? String
        
        plansArray.append(Plan(unwanderPlanID: currentplan_unwanderPlanID as! String, numCards: currentplan_numCards, stage: currentplan_stage!, title: currentplan_title!, startDate: nil, endDate: nil))
    }
   //  print(plansArray)
    return(plansArray)
    
}

func parseGetSpots(_ obj: Data, planID: String) -> [SpotDetailsItem]{
    var spotsArray = [SpotDetailsItem]()
    
    let parsedData = try? JSONSerialization.jsonObject(with: obj) as! [String:Any]
    let cards = parsedData?["cards"] as! [Any]
    
    for item in cards {
        
        
        let test1 = item as! [String:Any]
        let spotId =  test1["spotId"] as! [String:Any]
        //guard
        var spotId_latitude : Double? = nil
        var  spotiId_longitide : Double? = nil
        //print(spotId["geometry"])
        if let v = spotId["geometry"]{
            let a = (v as? [String: Any])
            if let v_lat = a?["location"] as? [String: Any ]{
                print(v_lat)
                if let latName = v_lat["lat"] as? String, let longName = v_lat["lng"] as? String {
                    let latitude = Double(latName) ?? 0.0
                    let longitude = Double(longName) ?? 0.0
                    spotId_latitude = latitude
                    spotiId_longitide = longitude
                    print(latitude)
                    print(longitude)
                    //And the rest of your code using latitude and longitude...
                }
                
            }
        }


        
        spotsArray.append(SpotDetailsItem(name: spotId["name"] as! String, address: spotId["address"] as? String, website: spotId["website"] as? String, spotID: spotId["_id"] as? String, unwanderPlanID: planID, phone_no: spotId["phone_no"] as? String, foursquare_venue_id: spotId["foursquare_venue_id"] as? String, place_id: spotId["place_id"] as! String, pics_url: spotId["pics_url"] as? [String], geometry: nil, displayPic: nil, latitude: spotId_latitude, longitude: spotiId_longitide))
        //print(spotId["pics_url"] as? [String])
    }
    return spotsArray

}
