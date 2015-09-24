//
//  SearchTableViewController.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchResultsViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var isLoading = false
    
    var searchResults: [StockSearchResult] = [
        StockSearchResult(symbol: "MRP", name: "Mighty", exchange: "NZ"),
    ]
    
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
    
    var debounceTimer: NSTimer?
    
    // This will be set in viewDidLoad
    var searchController: UISearchController!
    
    var yahooStockQuoteService = YahooStockQuoteService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Did select row \(indexPath.row)")
        let searchResult = searchResults[indexPath.row]
        let controller = storyboard?.instantiateViewControllerWithIdentifier("NewHoldingViewController") as! NewHoldingViewController
        controller.stockSearchResult = searchResult
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
        navigationController!.pushViewController(controller, animated: true)
    }
    
    // MARK: - Segues
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowNewHoldingSegue" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                
//            }
//        }
//    }
    
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
