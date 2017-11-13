//
//  PlansItem.swift
//  Auth0Sample
//
//  Created by Zubair Zahiruddin on 9/9/17.
//  Copyright © 2017 Auth0. All rights reserved.
//

import Foundation

struct Plan{
    let unwanderPlanID: String
  //  let created_at: Date
    let numCards: Int 
    let stage: String
    let title: String
    let savedFlag: Bool = false
    let startDate: Date?
    let endDate: Date?
}


