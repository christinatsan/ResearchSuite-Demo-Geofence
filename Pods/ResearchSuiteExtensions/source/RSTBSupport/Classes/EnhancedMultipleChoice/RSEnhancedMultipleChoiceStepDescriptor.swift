//
//  RSEnhancedMultipleChoiceStepDescriptor.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import Gloss
import ResearchSuiteTaskBuilder

extension RSAllowsEmptySelectionAlert {

    public static func fromJSON(json: JSON?) -> RSAllowsEmptySelectionAlert? {
        
        guard let json = json,
            let title: String = "title" <~~ json else {
            return nil
        }
        
        return RSAllowsEmptySelectionAlert(
            title: title,
            text: "text" <~~ json,
            cancelText: "cancelText" <~~ json ?? "Cancel",
            continueText: "continueText" <~~ json ?? "Continue"
        )
        
    }

}

public struct RSEnhancedMultipleChoiceAllowsEmptySelectionDescriptor: Gloss.JSONDecodable {
    
    public let allowed: Bool
    public let confirmationAlert: RSAllowsEmptySelectionAlert?
    
    public init?(json: JSON) {
        
        self.allowed = "allowed" <~~ json ?? false
        self.confirmationAlert = RSAllowsEmptySelectionAlert.fromJSON(json: "confirmation" <~~ json) 
        
    }
    
    
}

open class RSEnhancedMultipleChoiceStepDescriptor: RSTBChoiceStepDescriptor<RSEnhancedChoiceItemDescriptor> {

    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    public let allowsEmptySelection: RSEnhancedMultipleChoiceAllowsEmptySelectionDescriptor?
    
    required public init?(json: JSON) {
        
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        self.allowsEmptySelection = "allowsEmptySelection" <~~ json
        
        super.init(json: json)
    }
    
}

