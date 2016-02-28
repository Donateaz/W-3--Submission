//
//  Category.swift
//  Yelp
//
//  Created by Donatea Zefi on 2/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name: String?
    let imageName: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        imageName = dictionary["image"] as? String
    }
    
    var category : Category! {
        didSet {
            name = category.name
            //  categoryImageView.image = category.imageName
        }
    }
}
