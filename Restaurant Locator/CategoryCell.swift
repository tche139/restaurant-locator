//
//  CategoryCell.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/08/2017.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryTitleText: UILabel!
    @IBOutlet weak var CategoryIconImage: UIImageView!
    @IBOutlet weak var colorImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
