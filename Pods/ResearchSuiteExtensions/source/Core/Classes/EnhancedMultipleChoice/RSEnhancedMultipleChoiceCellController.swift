//
//  RSEnhancedMultipleChoiceCellController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/25/18.
//

import UIKit
import ResearchKit

public protocol RSEnhancedMultipleChoiceCellController {
    
    var identifier: String { get }
    var textChoice: RSTextChoiceWithAuxiliaryAnswer { get }
    var auxiliaryItem: ORKFormItem? { get }
    var isSelected: Bool { get }
    
    //this returns true if:
    // - the choice has no aux item
    // - or the aux item is valid
    // note that its unclear if an optional but invalid item just passes or must be empty...
    var isValid: Bool { get }
    
    var hasAuxiliaryItem: Bool { get }
//    func viewForAuxiliaryItem() -> UIView?
    
    var isAuxiliaryItemOptional: Bool? { get }
    var isAuxiliaryItemValid: Bool? { get }
    var auxiliaryItemResult: ORKResult? { get }
    
    var onValidationFailed: ((String) -> ())? { get set }
    
    func configureCell(cell: RSEnhancedMultipleChoiceCell, selected: Bool)
    func clearAnswer()
    
    //this is used to populate the VC result
    var choiceSelection: RSEnahncedMultipleChoiceSelection? { get }
    var onAuxiliaryItemResultChanged:(() -> ())? { get }
    
    func setFocused(isFocused: Bool)
    
}
