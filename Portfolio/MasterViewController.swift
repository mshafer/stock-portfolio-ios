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
    var holdings: [Holding] = [
        Holding(symbol: "MRP.NZ", name: "Mighty River Powahhhhhhhhhhhhh Ltd.", numberOfShares: 832, totalPurchasePrice: 2080, currencyCode: "NZD"),
        Holding(symbol: "GNE.NZ", name: "Genesis Energy Ltd.", numberOfShares: 1376, totalPurchasePrice: 2064, currencyCode: "JPY")
    ]
    var stockQuoteService: StockQuoteService = YahooStockQuoteService()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        stockQuoteService.getQuotesForHoldings(self.holdings, onCompletion: { _ in }, onError: { _ in print("Ooops") } )
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
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
        return holdings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HoldingCell", forIndexPath: indexPath) as! HoldingTableViewCell

        let holding = holdings[indexPath.row]
        holding.closingPrice = 2.50
        holding.currentPrice = 2.48
        
        setHoldingValues(holding, inTableViewCell: cell)
        setColours(holding, inTableViewCell: cell)
        
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
    
    func setHoldingValues(holding: Holding, inTableViewCell cell: HoldingTableViewCell) {
        cell.symbol.text = holding.symbol
        cell.name.text = holding.name
        cell.currentValue.text = Util.currencyToString(holding.currentValue, currencyCode: holding.currencyCode)
        cell.quantityAndPrice.text = holdingQuantityAndPrice(holding)
        cell.quantityAndPrice.sizeToFit()
        cell.changeTodayInDollars.text = Util.currencyToString(holding.changeTodayAsDollars, currencyCode: holding.currencyCode)
        cell.changeTodayAsPercentage.text = doubleToPercentage(holding.changeTodayAsFraction)
    }
    
    func setColours(holding: Holding, inTableViewCell cell: HoldingTableViewCell) {
        let colour: UIColor
        if (holding.changeTodayAsDollars >= 0) {
            colour = UIColor(hex: "#45BF55")
        } else {
            colour = UIColor.dangerColor()
        }
        
        cell.changeTodayInDollars.textColor = colour
        cell.changeTodayAsPercentage.textColor = colour
    }
    
    // MARK: - Computed strings for display in the UI
    
    func holdingQuantityAndPrice(holding: Holding) -> String {
        return [
            String(holding.numberOfShares),
            "@",
            Util.currencyToString(holding.currentPrice!, currencyCode: holding.currencyCode)
        ].joinWithSeparator("")
    }
    
    func doubleToPercentage(value: Double) -> String {
        return String(format: "%.1f%%", value * 100)
    }

}

