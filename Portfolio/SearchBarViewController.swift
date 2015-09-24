//
//  SearchBarViewController.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class SearchBarViewController: UITableViewController {

    // MARK: - Properties
    
    // `searchController` is set in viewDidLoad(_:).
    var searchController: UISearchController!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the search results view controller and use it for the `UISearchController`.
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier("SearchResultsViewController") as! SearchResultsViewController
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        /*
        Configure the search controller's search bar. For more information on
        how to configure search bars, see the "Search Bar" group under "Search".
        */
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Add a prompt above the
        navigationItem.prompt = "Type a company name or stock symbol"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
}
