//
//  Location.swift
//  Yelp
//
//  Created by Donatea Zefi on 2/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit;

class Location: NSObject, MKAnnotation {
    var title: String?;
    var coordinate: CLLocationCoordinate2D;
    var business: Business?;
    
    init(title: String, latitude: Double, longitude: Double, business: Business) {
        self.title = title;
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        self.business = business;
    }
}
