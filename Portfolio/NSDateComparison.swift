//
//  NSDateComparison.swift
//  Portfolio
//
//  Created by Michael Shafer on 26/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs == rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }