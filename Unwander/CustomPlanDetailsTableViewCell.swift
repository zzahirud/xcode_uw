//
//  CustomPlanDetailsTableViewCell.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/10/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit

class CustomPlanDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var spotTitle: UILabel!
    
    @IBOutlet weak var spotPic: UIImageView!
    
    @IBOutlet weak var spotAddress: UILabel!
    
  //  @IBOutlet weak var spotPic: UIImageView!
    
   // static var spotFlag:Bool
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.spotPic.layer.cornerRadius = self.spotPic.frame.width/8.0
        self.spotPic.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



class CustomPlanDetailsTableViewCell_nopic: UITableViewCell {
    
    @IBOutlet weak var spotTitle: UILabel!
    
   // @IBOutlet weak var spotPic: UIImageView!
    
    @IBOutlet weak var spotAddress: UILabel!
    
    //  @IBOutlet weak var spotPic: UIImageView!
    
    // static var spotFlag:Bool
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.spotPic.layer.cornerRadius = self.spotPic.frame.width/8.0
//        self.spotPic.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
