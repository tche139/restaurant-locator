//
//  RestaurantCell.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var cosmosView: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var restaurantCellImage: UIImageView!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
