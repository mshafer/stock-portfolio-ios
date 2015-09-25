//
//  EditHoldingDelegate.swift
//  Portfolio
//
//  Created by Michael Shafer on 25/09/15.
//  Copyright © 2015 mshafer. All rights reserved.
//

import Foundation

protocol EditHoldingDelegate {
    /**
        Called after a new Holding has been created
    */
    func newHoldingWasCreated(holding: Holding)
    
    /**
        Called after an existing Holding has been edited. The returned Holding be a new Holding instance
        with the new properties (i.e. the old one is not updated)
    */
    func holdingWasEdited(oldHolding: Holding, editedHolding: Holding)
}