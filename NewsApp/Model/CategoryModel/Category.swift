//
//  Category.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 15/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class Category {
    
    var id : String
    var name : String
    var backgroundImage : UIImage
    
    init(id : String, name : String, backgroundImage : UIImage) {
        self.id = id
        self.name = name
        self.backgroundImage = backgroundImage
    }
}
