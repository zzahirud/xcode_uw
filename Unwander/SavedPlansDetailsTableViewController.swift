//
//  SavedPlansDetailsTableViewController.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 10/3/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit

class SavedPlansDetailsTableViewController: UITableViewController {
    
    var tableData : [Spots] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(tableData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedplanSpots", for: indexPath) as! CustomPlanDetailsTableViewCell_nopic
        
        // Configure the cell...
        let spot = tableData[indexPath.row]
        cell.spotTitle.text = spot.name
        cell.spotAddress.text = processAddress(spot.address!)
        //cell.spotPic.image = nil
        
       // cell.
        
        //Configuring images
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        //Check that the segue is the right one
        if segue.identifier == "gotoSavedSpotDetails" {
            
            if let destination = segue.destination as? SavedSpotTableViewController {
                
                if let indexPath = tableView.indexPath(for: sender as! CustomPlanDetailsTableViewCell_nopic){
                    print(indexPath)
                    print( tableData[indexPath.row])
                    destination.currentSpot = tableData[indexPath.row]
                
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
