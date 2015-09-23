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
        } else {
            self.removeConstraint(self.constraintNameAndQuantityPriceHorizontalSpace)
        }
    }
}
