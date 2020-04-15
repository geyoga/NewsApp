//
//  Source.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 15/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class Sources: Codable {
    let sources : [Source]
    
    init(sources : [Source]) {
        self.sources = sources
    }
}

class Source: Codable {
    
    var id : String?
    var name : String?
    var description : String?
    var category : String?
    
    init(id : String, name : String, description : String, category : String) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
    }
}
