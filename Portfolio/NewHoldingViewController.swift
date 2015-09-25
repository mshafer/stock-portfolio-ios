//
//  NewHoldingViewController.swift
//  Portfolio
//
//  Created by Michael Shafer on 24/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import UIKit

class NewHoldingViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberOfSharesInput: UITextField!
    @IBOutlet var totalAmountPaidInput: UITextField!
    
    // MARK: - Properties
    
    // If true we are editing a Holding, if false we are creating a new one
    var inEditMode = false
    
    var stockQuoteService = YahooStockQuoteService()
    
    var doneButton : UIBarButtonItem!

    /**
        If this property gets set, it means we're entering the view to create a new Holding based on a
        search result.
    
        When this happens we want to query yahoo for more details about the stock and create a new Holding
    */
    var stockSearchResult: StockSearchResult? {
        didSet {
            self.inEditMode = false
            stockQuoteService.getQuoteForStockSymbol((self.stockSearchResult!.symbol),
                onCompletion: { stock in
                    self.stock = stock
                },
                onError: { _ in
                    // TODO: Handle error case
                })
        }
    }
    
    var stock: Stock? {
        didSet {
            self.configureView()
        }
    }
    
    var holding: Holding? {
        didSet {
            self.inEditMode = true
            self.stock = Stock(symbol: holding!.symbol, name: self.holding!.name, currencyCode: self.holding!.currencyCode)
        }
    }
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let symbol = self.stockSearchResult?.symbol {
            self.symbolLabel.text = symbol
            self.nameLabel.text = ""
        }
        
        self.addDoneButton()
        self.validateInputs()
        
        self.numberOfSharesInput.becomeFirstResponder()
        
        self.numberOfSharesInput.addTarget(self, action: Selector("validateInputs"), forControlEvents: UIControlEvents.EditingChanged)
        self.totalAmountPaidInput.addTarget(self, action: Selector("validateInputs"), forControlEvents: UIControlEvents.EditingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButton() {
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("doneEditing"))
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
    
    func doneEditing() {
        // Pop this view controller and return to list view
        print("Save the holding")
    }
    
    // MARK: - Rendering
    
    func configureView() {
        if inEditMode {
            self.title = "Edit Holding"
        } else {
            self.title = "New Holding"
        }
        
        self.symbolLabel.fadeTransition(0.4)
        self.symbolLabel.text = self.stock?.symbol
        
        self.nameLabel.fadeTransition(0.4)
        self.nameLabel.text = self.stock?.name
        
        self.numberOfSharesInput.fadeTransition(0.4)
        if let numberOfShares = self.holding?.numberOfShares {
            self.numberOfSharesInput.text = String(numberOfShares)
        }
        
        self.totalAmountPaidInput.fadeTransition(0.4)
        self.totalAmountPaidInput.placeholder = self.stock?.currencyCode
        if let price = self.holding?.totalPurchasePrice {
            self.totalAmountPaidInput.text = String(price)
        }
        
    }
    
    // MARK: - Validate Inputs
    
    func validateInputs() {
        if let _ = self.createHoldingFromInputs() {
            self.doneButton.enabled = true
        } else {
            self.doneButton.enabled = false
        }
    }
    
    func createHoldingFromInputs() -> Holding? {
        guard let numberOfShares = Int(self.numberOfSharesInput.text!),
            let totalAmountPaid = Double(self.totalAmountPaidInput.text!),
            let stock = self.stock
            else {
                return nil
            }
        
        return Holding(
            symbol: stock.symbol,
            name: stock.name,
            numberOfShares: numberOfShares,
            totalPurchasePrice: totalAmountPaid,
            currencyCode: stock.currencyCode
        )
    }

}
