//
//  Category.swift
//  Restaurant Locator
//
//  Created by Qingyun He on 10/8/17.
//  Copyright © 2017 max. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name:String!
    var icon:UIImage!
    var color:UIColor!
    

    init(name:String,icon:UIImage,color:UIColor){
        self.name=name
        self.icon=icon
        self.color=color
    }
}
