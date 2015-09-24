//
//  SearchBarViewController.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class SearchBarViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    // MARK: - Properties
    
    var debounceTimer: NSTimer?
    
    var yahooStockQuoteService = YahooStockQuoteService()
    
    // `searchController` is set in viewDidLoad(_:).
    var searchController: UISearchController!
    
    var isLoading = false
    
    var searchResults: [StockSearchResult] = []
    
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                searchResults = []
                self.tableView.reloadData()
            }
            else {
                self.stageRefreshOperation()
            }
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self as UISearchControllerDelegate
        searchController.searchBar.delegate = self as UISearchBarDelegate
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchController.active = true
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        searchController.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Data fetching
    
    /**
    Set a timer that when expired will refresh the search results. The timer only runs out if the user hasn't typed
    within some time threshold
    */
    func stageRefreshOperation() {
        isLoading = true
        tableView.reloadData()
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = NSTimer(timeInterval: 0.4, target: self, selector: Selector("refreshSearchResults"), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
    }
    
    func refreshSearchResults() {
        if let filterString = self.filterString {
            yahooStockQuoteService.searchForStockSymbols(filterString, onCompletion: self.onRefreshSuccess, onError: self.onRefreshError)
        }
    }
    
    func onRefreshSuccess(results: [StockSearchResult]) {
        isLoading = false
        self.searchResults = results
        self.tableView.reloadData()
    }
    
    func onRefreshError() {
        isLoading = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            return tableView.dequeueReusableCellWithIdentifier("LoadingCell")!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StockSearchResultCell", forIndexPath: indexPath) as! StockSearchResultTableViewCell
        
        cell.configureForSearchResult(searchResults[indexPath.row])
        
        return cell
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNewHoldingSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let searchResult = searchResults[indexPath.row]
                let controller = segue.destinationViewController as! NewHoldingViewController
                controller.stockSearchResult = searchResult
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard searchController.active else { return }
        
        filterString = searchController.searchBar.text
    }
    
    // MARK: - Cleanup
    
    override func viewDidDisappear(animated: Bool) {
        if let timer = debounceTimer {
            timer.invalidate()
        }
        super.viewDidDisappear(animated)
    }

}