//
//  Post.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import Foundation

struct Post: Codable {
    let date: String
    let link: URL
    let title: Rendered
    let content: Rendered
    let jetpack_featured_media_url: URL
}

struct Rendered: Codable {
    let rendered: String
}
