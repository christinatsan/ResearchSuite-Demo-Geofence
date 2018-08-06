//
//  RSEnhancedChoiceItemDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedChoiceItemDescriptor: RSTBChoiceItemDescriptor {
    
    open let identifier: String
    open let auxiliaryItem: JSON?
    
    public required init?(json: JSON) {
        
        //for backwards compatibility, use value for identifer if it's a string
        //note this might still break stuff
        guard let identifier: String = "identifier" <~~ json ?? "value" <~~ json else {
            return nil
        }
        
        self.identifier = identifier
        self.auxiliaryItem = "auxiliaryItem" <~~ json
        super.init(json: json)
        
    }

}
