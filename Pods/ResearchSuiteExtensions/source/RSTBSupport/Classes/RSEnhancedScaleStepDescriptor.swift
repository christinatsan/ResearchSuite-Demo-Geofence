//
//  RSEnhancedScaleStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedScaleStepDescriptor: RSTBScaleStepDescriptor {
    
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    
    public let minimumValueLabel: String?
    public let maximumValueLabel: String?
    public let minimumValueDescription: String?
    public let neutralValueDescription: String?
    public let maximumValueDescription: String?
    
    public required init?(json: JSON) {
        
        self.minimumValueLabel = "minimum_value_label" <~~ json
        self.maximumValueLabel = "maximum_value_label" <~~ json
        self.minimumValueDescription = "minimum_value_description" <~~ json
        self.neutralValueDescription = "neutral_value_description" <~~ json
        self.maximumValueDescription = "maximum_value_description" <~~ json
        
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        super.init(json: json)
        
    }

}
