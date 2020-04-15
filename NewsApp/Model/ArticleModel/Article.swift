//
//  Article.swift
//  NewsApp
//
//  Created by Georgius Yoga Dewantama on 14/04/20.
//  Copyright © 2020 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit

class Articles : Codable {
    
    let articles : [Article]
    
    init(articles : [Article]) {
        self.articles = articles
    }
}


class Article: Codable {
    
    var title : String?
    var description : String?
    var author : String?
    var urlToImage : String?
    var url : String?
    
    init(title : String, description : String, author : String, urlToImage : String, url : String) {
        self.title = title
        self.description = description
        self.author = author
        self.urlToImage = urlToImage
        self.url = url
    }
}
