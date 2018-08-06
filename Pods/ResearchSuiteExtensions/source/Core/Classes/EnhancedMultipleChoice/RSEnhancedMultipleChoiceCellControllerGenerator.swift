//
//  RSEnhancedMultipleChoiceCellControllerGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/27/18.
//

import UIKit

public protocol RSEnhancedMultipleChoiceCellControllerGenerator {
    
    static func supports(textChoice: RSTextChoiceWithAuxiliaryAnswer) -> Bool
    
    static func generate(
        textChoice: RSTextChoiceWithAuxiliaryAnswer,
        choiceSelection: RSEnahncedMultipleChoiceSelection?,
        onValidationFailed: ((String) -> ())?,
        onAuxiliaryItemResultChanged: (() -> ())?
        ) -> RSEnhancedMultipleChoiceCellController?
}
