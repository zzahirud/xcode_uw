//
//  MyPlansTableViewController.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/9/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit
import Auth0
import SimpleKeychain

@available(iOS 10.0, *)
class MyPlansTableViewController: UITableViewController, SwiftyTableViewCellDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Add the actions

    var tableData : [Plan] = [] // plans returned from web service.
    var savedPlans: [Plans] = []
    var savedPlanIDs : [String]? = []
    var savedSpots  : [Spots] = []
    
    var this_spot : Plan?
    var senderCell: CustomCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        savedPlans = getSavedLocalPlans()!
        for item in savedPlans{
            print(item.unwanderPlanID!)
            print(item.title!)
            //savedPlanIDs = []
            savedPlanIDs?.append(item.unwanderPlanID!)
        }
        
        print("printing saved spots")
         savedSpots  = getSavedSpots()!
        //print(savedSpots)
        for item in savedSpots {
            print(item.name)
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            WebService_callgetPlansAPI(completion: { success in
                // Call a function here to sync
                DispatchQueue.main.async {
                    print("plans webservice completed")
                    self.tableData = globalMyPlans
                    self.tableView.reloadData()
                }
            })
        }
        
        syncSavedPlans(savedPlanIDs!, savedSpots, savedPlans)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        let city = tableData[indexPath.row]
        cell.planTitle.text = city.title
        cell.numOfSpots.text = "\(city.numCards) spots"
        cell.delegate = self

        if (savedPlanIDs?.contains(city.unwanderPlanID))! {
            print("yes PlanID present locally")
            print(savedPlanIDs)
            cell.roundedCornerButton.setTitle("Delete", for: .normal)
        }

        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check that the segue is the right one
        if segue.identifier == "gotoPlanDetails" {
            
           // if segue.destination is PlanDetailsTableViewController  {
                if let destination = segue.destination as? PlanDetailsTableViewController {
                //Grab the data from your array
                if let indexPath = tableView.indexPathForSelectedRow?.row {
                   print(indexPath)
                   print( tableData[indexPath].title)
                    destination.self.title = tableData[indexPath].title
                   // destination.cities.append("ttt")
                    destination.planID = tableData[indexPath].unwanderPlanID
                }
            }
        }
    }
    

    

    let alert = UIAlertController(title: "Save Plan Locally", message: "You can save the plan locally on your phone storage to access it offline", preferredStyle: UIAlertControllerStyle.alert)
    
    let alertSync = UIAlertController(title: "Update Plan Locally", message: "Would you like to update your saved  plan with any changes you may have made to the selected plan", preferredStyle: UIAlertControllerStyle.alert)

    
    func swiftyTableViewCellDidTapSaveButton(_ sender: CustomCell) {
        
       //  self.activityIndicator.startAnimating();
        
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        let city = tableData[tappedIndexPath.row]
        print(city)
        this_spot = city
        senderCell = sender
        
        print("count of alerts \(self.alert.actions.count)")
      
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in

          //  self.activityIndicator.startAnimating();
            
            NSLog("OK Pressed")
            var city = self.this_spot
            //city?.unwanderPlanID
            //self.tableData[tappedIndexPath.row].unwanderPlanID
            savePlanlocally(city!,  completionB:  {_ in
                WebService_getSpotsfromPlanID(planID: city?.unwanderPlanID , completion: { success in
                    let spots = success
                    for item in spots{
                        print(item.name)
                        saveSpotlocally(item, completionB: { _ in
                            print("Done saving spots")
                        })
                    //saving spots to core data
                    }
                })
                //changing sync name
                //sender.roundedCornerButton.setTitle("sync", for: .normal)
                self.senderCell?.roundedCornerButton.setTitle("Delete", for: .normal)
                
            })
            
         //   self.activityIndicator.stopAnimating();
        }
        
        let okActionSync = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
         //   self.activityIndicator.startAnimating();
            
            NSLog("OK Sync Pressed")
            var city = self.this_spot
            self.savedPlans = getSavedLocalPlans()!
            print(self.savedPlans)
            
            self.savedSpots  = getSavedSpots()!
            
            for item in self.savedPlans{
                print(item.unwanderPlanID)
                print(city?.unwanderPlanID)
                if(item.unwanderPlanID == city?.unwanderPlanID){
                    self.context.delete(item)
                    
                    //deleting all spots
                    for spot in self.savedSpots{
                        if spot.unwanderPlanID == city?.unwanderPlanID{
                            print("deleting \(spot.unwanderPlanID)")
                            self.context.delete(spot)
                        }
                    }
                    
                    self.savedPlanIDs?.removeAll()
                do {
                    try self.context.save()
                    print("deletion complete")
                    self.senderCell?.roundedCornerButton.setTitle("Save", for: .normal)
                    
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }

        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        if (alert.actions.count == 0){
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }
        
        if (alertSync.actions.count == 0){
            alertSync.addAction(okActionSync)
            alertSync.addAction(cancelAction)
        }
        
        if(sender.roundedCornerButton.currentTitle == "Save"){
            self.present(alert, animated: true, completion: nil)
        }
        
        if(sender.roundedCornerButton.currentTitle == "Delete"){
            self.present(alertSync, animated: true, completion: nil)
        }

    }

}

