//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Donatea Zefi on 2/28/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var business: Business!;
    var data: NSDictionary?;
    
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var reviewerAge: UILabel!
    @IBOutlet weak var reviewerName: UILabel!
    @IBOutlet weak var reviewerPhoto: UIImageView!
    @IBOutlet weak var exploreMenuButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var reviewPreviewContent: UIView!
    @IBOutlet weak var reviewPreviewSeparator: UIView!
    @IBOutlet weak var reviewPreview: UIView!
    @IBOutlet weak var subAddressLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var locationSection: UIView!
    @IBOutlet weak var businessTitle: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingStars: UIImageView!
    @IBOutlet weak var pricepointLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var blureEffect: UIVisualEffectView!
    @IBOutlet weak var imageBackdrop: UIImageView!
    @IBOutlet weak var headView: UIView!
   
    @IBOutlet weak var reviewPreviewButtonsSeparator: UIView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        businessTitle.text =
            business.name;
        print(business.id);
        
        YelpClient.sharedInstance.lookupBusiness(business.id!, completion: { (data: NSDictionary!, error: NSError!) -> Void in
            self.data = data;
            self.configureViews();
            UIView.animateWithDuration(0.5, animations: {
                self.headView.alpha = 1;
                self.blureEffect.alpha = 1;
                self.imageBackdrop.alpha = 1;
                self.locationSection.alpha = 1;
                self.reviewPreview.alpha = 1;
            });
        });
        
        locationSection.layer.borderWidth = 1;
        locationSection.layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha: 1.0).CGColor;
        
        reviewPreview.layer.borderWidth = 1;
        reviewPreview.layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha: 1.0).CGColor;
        reviewPreviewSeparator.layer.borderWidth = 1;
        reviewPreviewSeparator.layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha: 1.0).CGColor;
        reviewPreviewButtonsSeparator.layer.borderWidth = 1;
        reviewPreviewButtonsSeparator.layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha: 1.0).CGColor;
        reviewPreviewContent.layer.borderWidth = 1;
        reviewPreviewContent.layer.borderColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha: 1.0).CGColor;
        
        let tap = UITapGestureRecognizer();
        tap.addTarget(self, action: "openInMaps");
        map.addGestureRecognizer(tap);
        locationSection.addGestureRecognizer(tap);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureViews() {
        let url = data!["image_url"] as! String;
        imageBackdrop.setImageWithURL(NSURL(string: url)!);
        distanceLabel.text = business.distance;
        pricepointLabel.text = "$$";
        ratingStars.setImageWithURL(NSURL(string: data!["rating_img_url_large"] as! String)!);
        map.showAnnotations([
            Location(
                title: data!["name"] as! String,
                latitude: data!["location"]!["coordinate"]!!["latitude"]! as! Double,
                longitude: data!["location"]!["coordinate"]!!["longitude"]!  as! Double,
                business: business
            )], animated: true
        );
        
        addressLabel.text = "";
        subAddressLabel.text = "";
        var addresses: [String] = data!["location"]!["display_address"]!! as! [String];
        if(addresses.count <= 3) {
            addressLabel.text = addresses[0];
            addresses.removeAtIndex(0);
            subAddressLabel.text = addresses.joinWithSeparator(", ");
        } else {
            addressLabel.text = (addresses[0] as String) + ", " + (addresses[1] as String);
            addresses.removeAtIndex(0);
            addresses.removeAtIndex(0);
            subAddressLabel.text = addresses.joinWithSeparator(", ");
        }
        
        reviewCount.text = data!["review_count"] as? String;
        
        var categories: [String] = [];
        for category in data!["categories"] as! [[String]] {
            categories.append(category[0]);
        }
        categoriesLabel.text = categories.joinWithSeparator(", ");
        
        reviewerPhoto.setImageWithURL(NSURL(string: data!["reviews"]![0]!["user"]!!["image_url"]! as! String)!);
        reviewerName.text = data!["reviews"]![0]!["user"]!!["name"]! as? String;
        review.text = data!["reviews"]![0]!["excerpt"]!! as? String;
        let unixCreationTime = NSDate(timeIntervalSince1970: data!["reviews"]![0]!["time_created"]!! as! Double);
        reviewerAge.text = timeSince(unixCreationTime) + " ago";
    }
    
    func openInMaps() {
        let latitude: CLLocationDegrees = data!["location"]!["coordinate"]!!["latitude"]! as! Double;
        let longitude: CLLocationDegrees =  data!["location"]!["coordinate"]!!["longitude"]!  as! Double;
        
        let regionDistance:CLLocationDistance = 10000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude);
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance);
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ];
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = business.name;
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    func initiateCall() {
        let phone = data!["phone"] as! String;
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func callBusiness(sender: AnyObject) {
        initiateCall();
    }
    
    func lowestReached(unit: String, value: Double) -> Bool {
        let value = Int(round(value));
        switch unit {
        case "s":
            return value < 60;
        case "m":
            return value < 60;
        case "h":
            return value < 24;
        case "d":
            return value < 60;
        default: // include "w". cannot reduce weeks
            return true;
        }
    }
    
    func timeSince(date: NSDate) -> String {
        var unit = "s";
        var timeSince = abs(date.timeIntervalSinceNow as Double); // in seconds
        var reductionComplete = lowestReached(unit, value: timeSince);
        
        while(reductionComplete != true){
            unit = "m";
            timeSince = round(timeSince / 60);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "h";
            timeSince = round(timeSince / 60);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "d";
            timeSince = round(timeSince / 24);
            if lowestReached(unit, value: timeSince) { break; }
            
            unit = "w";
            timeSince = round(timeSince / 7);
            if lowestReached(unit, value: timeSince) { break; }
        }
        
        let value = Int(timeSince);
        return "\(value)\(unit)";
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
  
    }
    


