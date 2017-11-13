//
//  Unwander_config.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/7/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation
import UIKit
import Auth0
import SimpleKeychain


let defaults:UserDefaults = UserDefaults.standard
var unwander_user_id:String?
var globalMyPlans : [Plan] = []
@available(iOS 10.0, *)
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


func getUnwanderUserID(shouldAuthenticate: Bool){
    
    let profilee = SessionManager.shared.profile
    let jsonData: [String: Any] = ["email":profilee?.email! as! String]
    let auth0user = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
    
    let urll = URL(string: "http://localhost:8080/api/users/auth0user")!
    var requestt = URLRequest(url: urll)
    requestt.setValue("application/json", forHTTPHeaderField: "Content-Type")
    requestt.httpMethod = "POST"
    requestt.httpBody = auth0user
    
    if shouldAuthenticate {
        guard let token = A0SimpleKeychain(service: "Auth0").string(forKey: "access_token") else {
            return
        }
        
        requestt.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    let taskk = URLSession.shared.dataTask(with: requestt) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            //print(responseJSON["_id"] as! String!)
            
            if let unwander_user_id:String = defaults.string(forKey: "unwander_user_id" ){
                print("saved user" +  (unwander_user_id))
            }
            else{
                let unwander_user_id = responseJSON["_id"] as! String!
                print("saving user" )
                defaults.set(unwander_user_id, forKey: "unwander_user_id")
            }
        }
    }
    
    taskk.resume()
}

func processAddress(_ address: String) -> String {
    //print(" Address is \(address)")
    var formattedAddress = String()
    if (address.components(separatedBy: ",")).count > 3{
        formattedAddress =  address.components(separatedBy: ",").suffix(3).joined()
        print (formattedAddress)
    }
    else{
        formattedAddress = address
    }
    
    return formattedAddress
}

@available(iOS 10.0, *)
func syncSavedPlans(_ savedplansids:[String], _ savedspots:[Spots], _ savedplansfull:[Plans]){
    
    // for each saved plan id
    // declare dictionary with saved spots and empty current spots
    // call web service to get spots
    // compare the two
    // if same pass
    // else detete and save using planID
    print(savedplansids.count)
    print(savedplansids)
    for planids in savedplansids {
        print(planids)
        var dict : [String:[String:Set<String>]] =
            [planids:["savedspotids": Set<String>(),"currentspots":Set<String>()]]
        
        let savedfullspots = savedspots.filter{$0.unwanderPlanID == planids}
        print(savedfullspots)
        for spot in savedfullspots{
            print(spot.spotID!)
            var a = String((spot.spotID!))!
            print(a)
            dict[planids]?["savedspotids"]?.insert(a)
        }
        WebService_getSpotsfromPlanID(planID: planids , completion: { success in
            let spots = success
            for item in spots{
                dict[planids]?["currentspots"]?.insert((item.spotID)!)
            }
            print(dict)
            if(dict[planids]?["currentspots"] != dict[planids]?["savedspotids"]){
            //DeletePlanAlso
            deleteSavedSpots(savedfullspots, completionB: { _ in
                print("Done Deleting spots")
                for item in spots{
                    saveSpotlocally(item, completionB:  { _ in
                        print("Done Saving Spot")
                    })
                }
            })
            //write the func to update plan here / call the func here
                syncSavedPlanwithSpots(planids, savedplansfull, (dict[planids]?["currentspots"])! )
            }
        })
        
        // [Spots]?
        //var savedplansfull = getSavedLocalPlans()
        /*
        for item in savedplansfull{
            if (planids == item.unwanderPlanID){
                print(item.unwanderPlanID)
                print(dict[planids]?["currentspots"])
               // item.setValue(8, forKey: "numCards")
            }
        }
        do {
            try context.save()
            print("saving done")
            
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        */
        
        //
        //print(dict)
    }
}




func WebService_getSpotsfromPlanID(planID: String?, completion: @escaping (_ success: [SpotDetailsItem] ) -> Void){
    
    let urlPath = "http://localhost:8080/api/plans/" + planID!
    
    guard let endpoint = URL(string: urlPath) else {
        print("Error creating endpoint")
        return
    }
    guard let token = A0SimpleKeychain(service: "Auth0").string(forKey: "access_token") else {return }
    
    var request = URLRequest(url: endpoint)
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request, completionHandler:  { (data, response, error) in
        let mySpots = parseGetSpots(data!, planID: planID!)
        print("done")
        completion(mySpots)
        
        })
    task.resume()
    print("function finishes")
}


func WebService_callgetPlansAPI( completion: @escaping (_ success: Bool ) -> Void) {
    
    unwander_user_id = defaults.string(forKey: "unwander_user_id" )
    //Request
    let url = URL(string: "http://localhost:8080/api/users/"+unwander_user_id!+"/plans")!
    var request = URLRequest(url: url)
    

    guard let token = A0SimpleKeychain(service: "Auth0").string(forKey: "access_token") else {return}
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    
    //URLSession
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        let myPlans = parseGetPlans(data!)
        globalMyPlans  = myPlans
        print("done")
        completion(true)
    })
    
    task.resume()
    print("fetching plans from web service")
}

@available(iOS 10.0, *)
func getSavedLocalPlans() -> [Plans]? {
    print("fetching local plans")
    var myPlans : [Plans] = []
    
    do {
        myPlans = try context.fetch(Plans.fetchRequest())
    } catch {
        print("Fetching Failed")
    }
    
    return myPlans
}

@available(iOS 10.0, *)
func getSavedSpots() -> [Spots]? {
    print("fetching local plans")
    var mySpots : [Spots] = []
    
    do {
        mySpots = try context.fetch(Spots.fetchRequest())
    } catch {
        print("Fetching Failed")
    }
    
    return mySpots
}

@available(iOS 10.0, *)
func savePlanlocally(_ selectedPlan: Plan, completionB: ((Bool) -> Void)) {
    
    //print(selectedPlan)
    print("saving plans locally")
     let currentPlan = Plans(context: context)
     
     currentPlan.title = selectedPlan.title
     currentPlan.numCards = Int64(Int16(selectedPlan.numCards))
     currentPlan.savedFlag = true
     currentPlan.stage = selectedPlan.stage
     currentPlan.unwanderPlanID = selectedPlan.unwanderPlanID
     currentPlan.startDate = nil
     currentPlan.endDate = nil
    
     
     do {
        try context.save()
        print("saving done")
     
     } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
     }
    completionB(true)

}


@available(iOS 10.0, *)
func saveSpotlocally(_ selectedSpot: SpotDetailsItem, completionB: ((Bool) -> Void)) {
    
    //print(selectedPlan)
    print("saving Spot locally")
    let currentSpot = Spots(context: context)
    
    currentSpot.name = selectedSpot.name
    currentSpot.address = selectedSpot.address
    currentSpot.latitude = selectedSpot.latitude!
    currentSpot.lng = selectedSpot.longitude!
    currentSpot.foursquare_venue_id = selectedSpot.foursquare_venue_id
    currentSpot.phone_no = selectedSpot.phone_no
    currentSpot.place_id = selectedSpot.place_id
    currentSpot.unwanderPlanID = selectedSpot.unwanderPlanID
    currentSpot.website = selectedSpot.website
    currentSpot.spotID = selectedSpot.spotID

    do {
        try context.save()
        print("saving done")
        
    } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    completionB(true)
    
}

@available(iOS 10.0, *)
func deleteSavedSpots(_ savedspots:[Spots], completionB: ((Bool) -> Void)) {
    
    //print(selectedPlan)
    print("Deleting Saved Spots")
    for spot in savedspots{
            print("deleting \(spot.spotID)")
            context.delete(spot)
    }
    
    do {
        try context.save()
        print("deleting done")
        
    } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    completionB(true)
    
}

@available(iOS 10.0, *)
func syncSavedPlanwithSpots(_ planid: String, _ savedplansfull:[Plans] ,_ currentspots:Set<String> ){
    for item in savedplansfull{
        if (planid == item.unwanderPlanID){
            print(item.unwanderPlanID)
            print(currentspots)
            print(currentspots.count)
            item.setValue(currentspots.count, forKey: "numCards")
        }
    }
    do {
        try context.save()
        print("saving done")
        
    } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    
}




/*
DispatchQueue.global(qos: .userInteractive).async {
    WebService_callgetPlansAPI(completion: { success in
        DispatchQueue.main.async {
            print(3)
            self.tableView.reloadData()
        }
    })
    print(2)
    }*/

/*
DispatchQueue.global(qos: .userInteractive).async {
    callgetPlansAPI(authenticated: true, completion: { success in
        DispatchQueue.main.async {
            print(3)
            self.tableView.reloadData()
        }
    })
}*/






//https://qa.unwander.com/#/plan/58fec704d304c2916fa0fe0d/collect
