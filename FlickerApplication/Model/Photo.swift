//
//  Photo.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 03/04/2021.
//

import Foundation

struct Photo: Codable,Identifiable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    var flickrImageURL:URL? {
        URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")
    }
}

struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

struct SearchResult: Codable {
    let photos: Photos
    let stat: String
}
