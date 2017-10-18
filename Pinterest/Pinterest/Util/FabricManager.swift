//
//  FabricManager.swift
//  Randomizer
//
//  Created by nguyen ha on 10/16/17.
//  Copyright © 2017 Ace. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics

class FabricManager: BaseUseCase {
    static let sharedInstance = FabricManager()
    
    func create() {
        Fabric.with([Crashlytics.self(), Answers.self()])
    }
    
    
}
