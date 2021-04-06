//
//  StubGeneratorUtility.swift
//  FlickerApplicationTests
//
//  Created by Sanket Sawant on 05/04/2021.
//

import Foundation
@testable import FlickerApplication

class StubGenerator {
    func stubSearchResults() -> SearchResult? {
        if let url = Bundle.main.url(forResource: "SearchResult", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let searchResults = try decoder.decode(SearchResult.self, from: data)
                return searchResults
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
