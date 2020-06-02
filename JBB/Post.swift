//
//  Post.swift
//  JBB
//
//  Created by Bobby Keffury on 5/26/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation

class Post: Codable {
    var date: String
    var link: String
    var title: Title
    var content: Content
    var categories: [Int]
    var jetpack_featured_media_url: String
    
    internal init(date: String, link: String, title: Title, content: Content, categories: [Int], photoString: String) {
        self.date = date
        self.link = link
        self.title = title
        self.content = content
        self.categories = categories
        self.jetpack_featured_media_url = photoString
    }
}

struct Title: Codable {
    var rendered: String
}

struct Content: Codable {
    var rendered: String
}
