//
//  HomeViewModelTestCase.swift
//  FlickerApplicationTests
//
//  Created by Sanket Sawant on 05/04/2021.
//

import XCTest
@testable import FlickerApplication

class HomeViewModelTests: XCTestCase {
    var homeViewModel: HomeViewModel!

    override func setUpWithError() throws {
       try super.setUpWithError()
        let searchResults = StubGenerator().stubSearchResults()
        homeViewModel = HomeViewModel()
        homeViewModel.perPageInt = searchResults!.photos.perpage
        homeViewModel.maxAvailablePhotos = Int(searchResults!.photos.total) ?? 0
        homeViewModel.currentPage = searchResults!.photos.page
        homeViewModel.photos.append(contentsOf: searchResults!.photos.photo)
    }

    override func tearDownWithError() throws {
        homeViewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func test_getPhotosForSearchText() {
        //Initiali viewModel to test
        let viewModel = HomeViewModel.init()
        viewModel.perPageInt = 15
        viewModel.maxAvailablePhotos = 239336
        viewModel.currentPage = 1
        
        //Validate if viewmodel is initialised correctly
        XCTAssertEqual(homeViewModel.perPageInt, viewModel.perPageInt)
        XCTAssertEqual(homeViewModel.currentPage, viewModel.currentPage)
        XCTAssertEqual(homeViewModel.maxAvailablePhotos, viewModel.maxAvailablePhotos)

    }
    
    //Check if calculate next page is working correctly
    func test_calculateNextPage() -> Void {
        XCTAssertNotNil(self.homeViewModel.calculateNextPage())
        XCTAssertEqual(self.homeViewModel.calculateNextPage()!, 2)
    }
}
