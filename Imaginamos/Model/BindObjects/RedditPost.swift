//
//  RedditPost.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation

class RedditPost {
    
    public var title = ""
    public var iconImg: String?
    public var submitText = ""
    public var advertiserCategory: String
    
    init(title: String, iconImg: String?, submitText: String, advertiserCategory: String) {
        self.title = title
        self.iconImg = iconImg
        self.submitText = submitText
        self.advertiserCategory = advertiserCategory
    }
}
