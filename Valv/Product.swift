//
//  Product.swift
//  Valv
//
//  Created by Hannes Gruber on 13/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    var uuid = ""
    var title = ""
    var category = ""
    var imageUuid = ""
    var imageLicense = ""
    var imageFallback = ""
    var desc = ""
    var ratingValue = ""
    var ratingCount = ""
    var userRating = ""
    var userProposedRating = ""
    
    func toString()->String {
        return "Product uuid:\(uuid) title:\(title) category:\(category)"
    }
   
}
