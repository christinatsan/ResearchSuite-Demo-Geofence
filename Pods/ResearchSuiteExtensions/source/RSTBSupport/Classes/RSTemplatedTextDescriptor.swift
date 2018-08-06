//
//  RSTemplatedTextDescriptor.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import Gloss

open class RSTemplatedTextDescriptor: Gloss.JSONDecodable {
    
    public let template: String
    public let arguments: [String: String]
    
    required public init?(json: JSON) {
        
        guard let template: String = "template" <~~ json else {
                return nil
        }
        
        self.template = template
        if let argumentsArray: [String] = "arguments" <~~ json {
            
            let pairs: [(String, String)] = argumentsArray.map { argument in
                return (argument, argument)
            }
            
            self.arguments = Dictionary.init(uniqueKeysWithValues: pairs)
        }
        else if let arguments: [String: String] = "argumentMapping" <~~ json {
            self.arguments = arguments
        }
        else {
            self.arguments = [:]
        }
        
        
        

    }

}
