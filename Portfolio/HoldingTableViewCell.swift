//
//  HoldingTableViewCell.swift
//  Portfolio
//
//  Created by Michael Shafer on 22/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation
import UIKit

class HoldingTableViewCell: UITableViewCell {
    @IBOutlet var symbol: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var currentValue: UILabel!
    @IBOutlet var quantityAndPrice: UILabel!
    @IBOutlet var changeTodayInDollars: UILabel!
    @IBOutlet var changeTodayAsPercentage: UILabel!
    @IBOutlet var constraintNameAndQuantityPriceHorizontalSpace: NSLayoutConstraint!
    @IBOutlet var constraintSymbolAndCurrentValueHorizontalSpace: NSLayoutConstraint!
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.setVisibilityOfValues(!editing)
    }
    
    func setVisibilityOfValues(isVisible: Bool) {
        self.currentValue.hidden = !isVisible;
        self.quantityAndPrice.hidden = !isVisible;
        self.changeTodayInDollars.hidden = !isVisible;
        self.changeTodayAsPercentage.hidden = !isVisible;
        
        if isVisible {
            self.addConstraint(self.constraintNameAndQuantityPriceHorizontalSpace)
            self.addConstraint(self.constraintSymbolAndCurrentValueHorizontalSpace)
        } else {
            self.removeConstraint(self.constraintNameAndQuantityPriceHorizontalSpace)
            self.removeConstraint(self.constraintSymbolAndCurrentValueHorizontalSpace)
        }
    }
    
    func configureForHolding(holding: Holding) {
        self.setHoldingValues(holding)
        self.setColours(holding)
    }
    
    func setHoldingValues(holding: Holding) {
        self.symbol.text = holding.symbol
        self.name.text = holding.name
        self.currentValue.text = holding.currentValue == nil ? "-" : Util.currencyToString(holding.currentValue!, currencyCode: holding.currencyCode)
        self.quantityAndPrice.text = holdingQuantityAndPrice(holding)
        self.quantityAndPrice.sizeToFit()
        self.changeTodayInDollars.text = holding.changeTodayAsDollars == nil ? "-" : Util.currencyToString(holding.changeTodayAsDollars!, currencyCode: holding.currencyCode)
        self.changeTodayAsPercentage.text = holding.changeTodayAsFraction == nil ? "-" : Util.fractionToPercentage(holding.changeTodayAsFraction!)
    }
    
    func setColours(holding: Holding) {
        let colour: UIColor
        if (holding.changeTodayAsDollars == nil || holding.changeTodayAsDollars >= 0) {
            colour = UIColor(hex: "#45BF55")
        } else {
            colour = UIColor.dangerColor()
        }
        
        self.changeTodayInDollars.textColor = colour
        self.changeTodayAsPercentage.textColor = colour
    }
    
    // MARK: - Computed strings for display in the UI
    
    func holdingQuantityAndPrice(holding: Holding) -> String {
        let price = holding.currentPrice == nil ? "-" : Util.currencyToString(holding.currentPrice!, currencyCode: holding.currencyCode)
        
        return [
            String(holding.numberOfShares),
            "@",
            price
            ].joinWithSeparator("")
    }
}
