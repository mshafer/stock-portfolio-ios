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
}
