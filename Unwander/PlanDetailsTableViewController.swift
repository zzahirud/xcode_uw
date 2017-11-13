//
//  PlanDetailsTableViewController.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/10/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit
import Auth0
import SimpleKeychain

class PlanDetailsTableViewController: UITableViewController {
    
    var planID: String?
    var tableData : [SpotDetailsItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        func getSpotsfromPlanID() {
            let urlPath = "http://localhost:8080/api/plans/" + planID!
            guard let endpoint = URL(string: urlPath) else {
                print("Error creating endpoint")
                return
            }
            guard let token = A0SimpleKeychain(service: "Auth0").string(forKey: "access_token") else {return}
            var request = URLRequest(url: endpoint)
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                let mySpots = parseGetSpots(data!, planID: self.planID!)
                self.tableData = mySpots
                self.tableView.reloadData()
                print("done")
                }.resume()
        }

        DispatchQueue.global(qos: .userInteractive).async {
            getSpotsfromPlanID()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        DispatchQueue.global(qos: .userInteractive).async {
            WebService_getSpotsfromPlanID(planID: self.planID , completion: { success in
                DispatchQueue.main.async {
                    print("plans webservice completed")
                    self.tableData = success
                    self.tableView.reloadData()
                }

                /*
                let spots = success
                self.tableData = spots
                for item in spots{
                    print(item.name)
                    //saving spots to core data
                }*/
            })

        }
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planSpots", for: indexPath) as! CustomPlanDetailsTableViewCell

        // Configure the cell...
        let spot = tableData[indexPath.row]
        cell.spotTitle.text = spot.name
        cell.spotAddress.text = processAddress(spot.address!)
        cell.spotPic.image = nil
        
        //Configuring images
        
        //https://igx.4sqi.net/img/general/960x960/1713151_GCkxIRTFNe7M2SDXxWTBvrJa_NbP7w_DJoS3BxvP-ew.jpg
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let picURL = (spot.pics_url?.first) else {
                return
            }
           // if let url = NSURL(string: ((spot.pics_url?.first))!)  {
            if let url = NSURL(string: picURL)  {
            //Do this network stuff on the background thread
            if let data = NSData(contentsOf: url as URL) {
                let imageAux = UIImage(data: data as Data)
            //Switch back to the main thread to do the UI stuff
                DispatchQueue.main.async(execute: {
                    cell.spotPic.image = imageAux
                    
                    }
                )}
            }
         }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        //Check that the segue is the right one
        if segue.identifier == "gotoSpotDetails" {
            
            if let destination = segue.destination as? SpotDetailsTableViewController {                
                if let indexPath = tableView.indexPath(for: sender as! CustomPlanDetailsTableViewCell){
                    print(indexPath)
                    print( tableData[indexPath.row])
                    destination.currentSpot = tableData[indexPath.row]
                }
            }
        }
    }
}
