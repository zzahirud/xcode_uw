//
//  SavedPlansTableViewController.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/28/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SavedPlansTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Add the actions
    
    var tableData : [Plan] = []
    var savedPlans: [Plans] = []
    var savedPlanIDs : [String]? = []
    var savedSpots  : [Spots] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        savedPlans = getSavedLocalPlans()!
        for item in savedPlans{
            print(item.unwanderPlanID!)
            print(item.title!)
            savedPlanIDs?.append(item.unwanderPlanID!)
        }
        
        print("printing saved spots")
        savedSpots  = getSavedSpots()!
        //print(savedSpots)
        for item in savedSpots {
            print(item.name)
            print(item.latitude)
            print(item.address)
            print(item.lng)
        }
        
       // self.tableData = savedPlans
        self.tableView.reloadData()
        
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedPlans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedplancell", for: indexPath)

        // Configure the cell...
        let savedPlan = savedPlans[indexPath.row]
        print(savedPlan.title)
        print(savedPlan.numCards)
        print(savedPlan.stage)
        cell.textLabel?.text = savedPlan.title
        cell.detailTextLabel?.text = "\(savedPlan.numCards) spots"
//        cell.planTitle.text = city.title
//        cell.numOfSpots.text = "\(city.numCards) spots"
//        cell.delegate = self

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check that the segue is the right one
        
        if segue.identifier == "gotoSavedPlanDetails" {
            
            // if segue.destination is SavedPlansDetailsTableViewController  {
            if let destination = segue.destination as? SavedPlansDetailsTableViewController {
                //Grab the data from your array
                if let indexPath = tableView.indexPathForSelectedRow?.row {
                    print(indexPath)
                    print( savedPlans[indexPath].title)
                    destination.self.title = savedPlans[indexPath].title
                    // destination.cities.append("ttt")
                    //let digits = [1,4,10,15]
                    //let even = digits.filter { $0 % 2 == 0 }
                    destination.tableData = self.savedSpots.filter {$0.unwanderPlanID == savedPlans[indexPath].unwanderPlanID! }
                }
            }
        }
    }
    


}
