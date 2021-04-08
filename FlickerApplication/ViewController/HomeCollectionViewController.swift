//
//  HomeCollectionViewController.swift
//  FlickerApplication
//
//  Created by Sanket Sawant on 03/04/2021.
//

import UIKit

private let collectionReuseIdentifier = "collectionViewCell"
private let tableReuseIndentifier = "tableViewCell"

class HomeCollectionViewController: UIViewController,UICollectionViewDelegate {

    // MARK: - Properties
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    @IBOutlet var collectionView:UICollectionView!
    @IBOutlet var recentSearchTableView:UITableView!
    
    @IBOutlet var noResultView:UIView!
    let searchController = UISearchController(searchResultsController: nil)

    lazy var placeholderImage: UIImage = {
        let image = UIImage(named: "PlaceholderImage")!
        return image
    }()
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    let viewModal: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchBar()
        self.configureRecentSearchTableView()
        self.bindDataModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.searchTextField.becomeFirstResponder()
    }
    
    //Bind viewModel with controller for data updates
    func bindDataModel() {
        self.noResultView.isHidden = true
        
        self.viewModal.onPhotosChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.showHideCollectionView()
                self?.collectionView.reloadData()
                self?.recentSearchTableView.reloadData()
            }
        }
        
        self.viewModal.showErrorAlert = {  [weak self] in
            self?.showErrorAlert()
        }
    }
    
    func showErrorAlert() {
        showAlertMessage(title: Constants.appTitle,
                         message: Constants.genericErrorMessage)
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //Configure search bar controller
    func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Flickr"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["Results","Recent"]
        searchController.searchBar.showsScopeBar = true
    }
    
    // Configure table view for recent search history
    func configureRecentSearchTableView() {
        self.recentSearchTableView.backgroundColor = UIColor.clear
        self.recentSearchTableView.tableFooterView = UIView()
        self.recentSearchTableView.separatorStyle = .singleLine
        self.recentSearchTableView.dataSource = self
        self.recentSearchTableView.delegate = self
    }
    
    func showHideCollectionView() -> Void {
        let isPhotoArrayEmpty = self.viewModal.photos.count == 0
        let selectedIndex = self.searchController.searchBar.selectedScopeButtonIndex
        let noResultsFound = isPhotoArrayEmpty && !self.isSearchBarEmpty
        
        if selectedIndex == 0 {
            self.collectionView.isHidden = noResultsFound
            self.recentSearchTableView.isHidden = true
            self.noResultView.isHidden = !noResultsFound
        } else {
            self.collectionView.isHidden = true
            self.recentSearchTableView.isHidden = false
            self.noResultView.isHidden = true
        }
    }
    
    func onSearch(with searchString:String?) {
        //Make result scope bar for showing result and show result collection view
        self.searchController.searchBar.selectedScopeButtonIndex = 0
        self.showHideCollectionView()
        //Fetch results for search string
        self.viewModal.getPhotosFor(searchText: searchString)
    }
}

// MARK: UICollectionViewDataSource
// Collection view will be used to show search results
extension HomeCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModal.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath) as? FlickImageCollectionViewCell else { return UICollectionViewCell() }
        let photo = self.viewModal.photos[indexPath.row]
        cell.configureCell(with: photo, placeholderImage: placeholderImage)
        cell.maxWidth = collectionView.bounds.width - sectionInsets.left
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = 200
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        // Load next batch of results once collectionView scrolls to bottom
        if (bottomEdge + CGFloat(offset) >= scrollView.contentSize.height) {
            //Load next pages for search string.
            guard let searchText = self.searchController.searchBar.text else { return }
            guard searchText.count > 0 else { return }
            self.viewModal.getPhotosFor(searchText: searchText)
        }
    }
}

// MARK: UISearchBarDelegate to handle search
extension HomeCollectionViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        self.onSearch(with: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.onSearch(with: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        self.onSearch(with: searchBar.searchTextField.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.showHideCollectionView()
    }
}

// MARK: UITableViewDataSource,UITableViewDelegate for handling search results
extension HomeCollectionViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModal.recentSearched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIndentifier) else {
               return UITableViewCell(style: .default, reuseIdentifier: tableReuseIndentifier)
               }
               return cell
           }()
        cell.textLabel?.text = self.viewModal.recentSearched[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.searchController.searchBar.text = self.viewModal.recentSearched[indexPath.row]
        self.searchController.searchBar.becomeFirstResponder()
    }
}
