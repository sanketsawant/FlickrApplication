//
//  SearchResults.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 07/04/2021.
//

import Foundation

struct SearchResult: Codable {
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}
