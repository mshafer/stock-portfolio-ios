//
//  MasterViewController.swift
//  Portfolio
//
//  Created by Michael Shafer on 22/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var holdings: [Holding] = []
    var encounteredErrorLoadingData = false
    var stockQuoteService: StockQuoteService = YahooStockQuoteService()
    var userHoldingsService: UserHoldingsService = UserHoldingsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        // Set up the Add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        // Configure the detailViewController
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.setContentOffset(CGPointMake(0, -self.refreshControl!.frame.size.height), animated: true)
        self.refreshControl?.beginRefreshing()
        self.refresh(self)
        
        // For debugging
//        let holdings = [
//            Holding(symbol: "MRP.NZ", name: "Mighty River Power Ltd.", numberOfShares: 832, totalPurchasePrice: 2080, currencyCode: "NZD"),
//            Holding(symbol: "GNE.NZ", name: "Genesis Energy Ltd.", numberOfShares: 1376, totalPurchasePrice: 2064, currencyCode: "JPY")
//        ]
//        userHoldingsService.saveUserHoldings(self.holdings)
//        self.holdings = userHoldingsService.loadUserHoldings()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        holdings.insert(Holding(symbol: "HEY", name: "Heyoo", numberOfShares: 1000, totalPurchasePrice: 10000, currencyCode: "NZD"), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Refresh model
    
    func refresh(sender:AnyObject) {
        print("I'm gonna refresh now!")
        self.holdings = userHoldingsService.loadUserHoldings()
        stockQuoteService.getQuotesForHoldings(self.holdings,
            onCompletion: self.onRefreshSuccess,
            onError: self.onRefreshError)
    }
    
    func onRefreshSuccess(_: [Holding]) {
        // The StockQuoteService directly modifies the holdings in the array so we don't actually need to use
        // the holdings argument given to us
        self.encounteredErrorLoadingData = false
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        self.userHoldingsService.saveUserHoldings(self.holdings)
    }
    
    func onRefreshError() {
        self.encounteredErrorLoadingData = true
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let holding = holdings[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = holding
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if encounteredErrorLoadingData {
            return 1
        } else {
            return holdings.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (encounteredErrorLoadingData) {
            return tableView.dequeueReusableCellWithIdentifier("ErrorCell")!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HoldingCell", forIndexPath: indexPath) as! HoldingTableViewCell
        let holding = holdings[indexPath.row]
        cell.configureForHolding(holding)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing {
            return .Delete
        } else {
            return .None
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            holdings.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // Yes, the table view can be reordered
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let holding = holdings[fromIndexPath.row]
        holdings.removeAtIndex(fromIndexPath.row)
        holdings.insert(holding, atIndex: toIndexPath.row)
    }
    
//    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
//        print("Will edit cell")
//        let holdingCell = tableView.cellForRowAtIndexPath(indexPath) as! HoldingTableViewCell
//        holdingCell.setVisibilityOfValues(false)
//    }
//    
//    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
//        print("Finished editing cell")
//        let holdingCell = tableView.cellForRowAtIndexPath(indexPath) as! HoldingTableViewCell
//        holdingCell.setVisibilityOfValues(true)
//    }
    
    // MARK: Table cell render functions
    
    

}

