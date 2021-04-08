//
//  NetworkManager.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 04/04/2021.
//

import Foundation
import Alamofire

enum APIError: String, Error {
    case invalidURL         = "Invalid url"
    case invalidAPIKey      = "Invalid API of flickr"
    case unableToComplete   = "Unable to complete request"
    case invalidResponse    = "Invalid response"
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func getSearchResults(for searchTerm:String, page:Int, completed: @escaping (Result<Photos, APIError>) -> Void)   {
        let endPoind = "\(Constants.urlPoint)method=flickr.photos.search&api_key=\(Constants.apiKey)&format=json&nojsoncallback=1&text=\(searchTerm)&page=\(page)&per_page=50"
        AF.request(endPoind).validate().responseDecodable(of: SearchResult.self) { (response) in
            guard response.response?.statusCode == 200 else {
                completed(.failure(APIError.invalidResponse))
                return
            }
            guard let searchResults = response.value else { return }
            completed(.success(searchResults.photos))
          }
    }
}
