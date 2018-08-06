//
//  RSEmailStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class RSEmailStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["emailStep"]
    }
    
    open func generateMessageBody(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> String? {
        guard let stepDescriptor = RSEmailStepDescriptor(json:jsonObject) else {
            return nil
        }
        
        return stepDescriptor.messageBody
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSEmailStepDescriptor(json:jsonObject),
            let stateHelper = helper.stateHelper else {
                return nil
        }
        
        let messageBody: String? = self.generateMessageBody(type: type, jsonObject: jsonObject, helper: helper)
        
        let step = RSEmailStep(
            identifier: stepDescriptor.identifier,
            recipientAddreses: stepDescriptor.recipientAddreses,
            messageSubject: stepDescriptor.messageSubject,
            messageBody: messageBody,
            bodyIsHTML: stepDescriptor.bodyIsHTML,
            errorMessage: stepDescriptor.errorMessage,
            buttonText: stepDescriptor.buttonText ?? "Next"
        )
        
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    
    
}
