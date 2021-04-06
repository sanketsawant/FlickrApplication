//
//  HomeViewModel.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 05/04/2021.
//

import Foundation

class HomeViewModel {
    var photos: [Photo] = [] {
        didSet {
            onPhotosChanged?()
        }
    }
    var currentPage = 0
    var maxAvailablePhotos = 0
    var searchTextString:String?
    var perPageInt:Int?
    var onPhotosChanged: (() -> Void)?
    var showErrorAlert: (() -> Void)?
    var recentSearched: [String] = [String]()
    
    /// Calculate next page number
    /// If photo array count is 0 then assume first time load
    /// If all images are loaded return nil
    /// - Returns: next page number or nil if all images are loaded
    func calculateNextPage() -> Int? {
        guard photos.count != 0 else { return 0 }
        guard let perPagePhoto = self.perPageInt else { return 0 }
        let nextPage = currentPage + 1
        let totalImagesLoaded = currentPage * perPagePhoto
        if totalImagesLoaded >= maxAvailablePhotos && totalImagesLoaded != 0 {
            return nil
        }
        return nextPage
    }
    
    // Reinitialise details once search text is changes or cancelled
    func reInitialiseDetails() {
        self.photos = []
        self.currentPage = 0
        self.maxAvailablePhotos = 0
        self.searchTextString = nil
    }
    
    // Get photos for search string
    func getPhotosFor(searchText:String?) -> Void {
        //Reinialise details if search text is nil
        guard let searchText = searchText else {
            self.reInitialiseDetails()
            return
        }
        //Reinialise if search text is different than previous search text
        if searchText != self.searchTextString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
            //Reset the details for reload
            self.reInitialiseDetails()
        }

        self.searchTextString = searchText
        guard self.calculateNextPage() != nil else { return }
        self.insertSearchStringInArray(searchString: searchText)
        
        NetworkManager.shared.getSearchResults(for: searchText, page: self.calculateNextPage()!) {[weak self] (result) in
            switch result {
            case .success(let searchResult):
                self?.currentPage = searchResult.page
                self?.perPageInt = searchResult.perpage
                self?.maxAvailablePhotos = Int(searchResult.total) ?? 0
                self?.photos.append(contentsOf: searchResult.photo)
            case .failure(_):
                self?.showErrorAlert?()
            }
        }
    }
    
    //Save search string in recent search
    func insertSearchStringInArray(searchString:String) {
        if let index = self.recentSearched.firstIndex(of: searchString) {
            //Remove existing item and add again at 0th index
            self.recentSearched.remove(at: index)
        }
        self.recentSearched.insert(searchString, at: 0)
    }
}
