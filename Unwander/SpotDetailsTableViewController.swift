//
//  SpotDetailsTableViewController.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/25/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit

class SpotDetailsTableViewController: UITableViewController {
    
    var currentSpot: SpotDetailsItem?
    
    @IBOutlet weak var savedTitle: UILabel!
    @IBOutlet weak var savedPhone: UITextView!
    @IBOutlet weak var savedAddress: UITextView!
    @IBOutlet weak var savedWebsite: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "title")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.currentSpot?.address)
        self.savedTitle.text = self.currentSpot?.name
            ?? "N?A"
        self.savedPhone.text = self.currentSpot?.phone_no
            ?? "N?A"
        self.savedAddress.text = self.currentSpot?.address
            ?? "N?A"
        self.savedWebsite.text = self.currentSpot?.website ?? "N/A"
    }
    
}

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "namecell")
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "addresscell")
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "telcell")
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "websitecell")
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "notescell")
//        
//        tableView.estimatedRowHeight = 44
//        tableView.rowHeight = UITableViewAutomaticDimension
//
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 5
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "namecell", for: indexPath)
//            cell.textLabel?.text = currentSpot?.name
//            //cell.backgroundColor = grey
//
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "addresscell", for: indexPath)
//            cell.textLabel?.text = currentSpot?.address
//            cell.textLabel?.numberOfLines = 0
//            cell.imageView?.image = #imageLiteral(resourceName: "marker")
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "telcell", for: indexPath)
//            cell.textLabel?.text = currentSpot?.phone_no
//            cell.imageView?.image  = #imageLiteral(resourceName: "phone")
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "websitecell", for: indexPath)
//            cell.textLabel?.text = currentSpot?.website
//            cell.textLabel?.numberOfLines = 0
//            cell.imageView?.image = #imageLiteral(resourceName: "link")
//            return cell
//        case 4:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "notescell", for: indexPath)
//            cell.textLabel?.text = "No Notes"
//            cell.imageView?.image = #imageLiteral(resourceName: "notes")
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "notescell", for: indexPath)
//            
//            return cell
    
            
        //}
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        // Configure the cell...
//
//        return cell
   // }
    



