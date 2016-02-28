//
//  SearchCell.swift
//  Yelp
//
//  Created by Donatea Zefi on 2/27/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!

    var category : Category! {
        didSet {
            categoryNameLabel.text = category.name
            //  categoryImageView.image = category.imageName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
