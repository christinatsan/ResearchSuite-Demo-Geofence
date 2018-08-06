//
//  RSEnhancedMultipleChoiceStep.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit
import Gloss

open class RSAllowsEmptySelectionAlert {
    
    public let title: String
    public let text: String?
    public let cancelText: String
    public let continueText: String
    
    public init(
        title: String,
        text: String?,
        cancelText: String,
        continueText: String) {
        self.title = title
        self.text = text
        self.cancelText = cancelText
        self.continueText = continueText
    }
    
}

open class RSEnhancedMultipleChoiceStep: RSStep {
    
    open var answerFormat: ORKTextChoiceAnswerFormat?
    open var cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]
    open var allowsEmptySelection: Bool = false
    open var emptySelectionConfirmationAlert: RSAllowsEmptySelectionAlert? = nil
    
    public init(identifier: String, title: String?, text: String?, answer answerFormat: ORKTextChoiceAnswerFormat?, cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]) {
        self.answerFormat = answerFormat
        self.cellControllerGenerators = cellControllerGenerators
        super.init(identifier: identifier)
        self.title = title
        self.text = text
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEnhancedMultipleChoiceStepViewController.self
    }

}
