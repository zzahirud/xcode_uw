//
//  CustomCell.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/9/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var planTitle: UILabel!
    
    @IBOutlet weak var numOfSpots: UILabel!
    
    @IBOutlet weak var roundedCornerButton: UIButton!
    weak var delegate: SwiftyTableViewCellDelegate?
    
    @IBAction func savePlan(_ sender: UIButton) {
        print("test")
        delegate?.swiftyTableViewCellDidTapSaveButton(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedCornerButton.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol SwiftyTableViewCellDelegate : class {
    func swiftyTableViewCellDidTapSaveButton(_ sender: CustomCell)
    //func swiftyTableViewCellDidTapTrash(_ sender: CustomCell)
}
