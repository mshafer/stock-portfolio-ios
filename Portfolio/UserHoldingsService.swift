//
//  UserPreferencesService.swift
//  Portfolio
//
//  Created by Michael Shafer on 23/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

/**
    Handles the persistence of the user's holdings
*/
class UserHoldingsService {
    var HOLDINGS_FILE_NAME = "holdings"
    
    func holdingsDocumentPath() -> String {
        return Util.documentsDirectory().stringByAppendingPathComponent(HOLDINGS_FILE_NAME)
    }
    
    /**
        Persist the array of Holdings to a file, and return true if the operation was successful.
    */
    func saveUserHoldings(holdings: [Holding]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(holdings, toFile: holdingsDocumentPath())
    }
    
    /**
        Load the user's Holdings from disk. If it could not find any Holdings, return an empty array.
    */
    func loadUserHoldings() -> [Holding] {
        guard let holdings = NSKeyedUnarchiver.unarchiveObjectWithFile(holdingsDocumentPath()) as? [Holding] else {
            return []
        }
        
        return holdings
    }
}
