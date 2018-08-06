//
//  RSAlert.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 6/26/18.
//

import UIKit
import Gloss

open class RSAlertChoice: Gloss.JSONDecodable {
    
    public let title: String
    public let style: UIAlertActionStyle
    public let onTapActions: [JSON]
    
    private static func styleFor(_ styleString: String) -> UIAlertActionStyle? {
        switch styleString {
        case "default":
            return .default
        case "cancel":
            return .cancel
        case "destructive":
            return .destructive
        default:
            return nil
        }
    }
    
    required public init?(json: JSON) {
        
        guard let title: String = "title" <~~ json,
            let styleString: String = "style" <~~ json,
            let style = RSAlertChoice.styleFor(styleString) else {
                return nil
        }
        
        self.title = title
        self.style = style
        self.onTapActions =  "onTap" <~~ json ?? []
    }
    
}

open class RSAlert: Gloss.JSONDecodable {
    
    public let title: String
    public let text: String?
    public let choices: [RSAlertChoice]
    
    required public init?(json: JSON) {
        
        guard let title: String = "title" <~~ json else {
            return nil
        }
        
        self.title = title
        self.text = "text" <~~ json
        self.choices = "choices" <~~ json ?? []
    }
    
}
