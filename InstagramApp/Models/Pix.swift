//
//  Pix.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation
import UIKit

struct Pix {
    let imageURL: String
    let itemName: String
    let details: String
    let id: String
    let listedDate: Date
    let postedBy: String
    let postedById: String
}
extension Pix {
    init(_ dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? "no image url"
        self.itemName = dictionary["itemName"] as? String ?? "no item name"
        self.details = dictionary["details"] as? String ?? "no details"
        self.id = dictionary["id"] as? String ?? "no id"
        self.listedDate = dictionary["listedDate"] as? Date ?? Date()
        self.postedBy = dictionary["postedBy"] as? String ?? "no postedby"
        self.postedById = dictionary["postedById"] as? String ?? "no posted by Id"
        
    }
    
}

