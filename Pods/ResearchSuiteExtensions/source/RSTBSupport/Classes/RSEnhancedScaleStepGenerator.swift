//
//  RSEnhancedScaleStepGenerator.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import Gloss
import ResearchSuiteTaskBuilder
import ResearchKit

open class RSEnhancedScaleStepGenerator: RSTBBaseStepGenerator, RSTBAnswerFormatGenerator {
    public func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public func processStepResult(type: String, jsonObject: JsonObject, result: ORKStepResult, helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    public init(){}
    
    let _supportedTypes = [
        "enhancedScale"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateChoices(items: [RSTBChoiceItemDescriptor]) -> [ORKTextChoice] {
        
        return items.map { item in
            
            return ORKTextChoice(
                text: item.text,
                detailText: item.detailText,
                value: item.value,
                exclusive: item.exclusive)
        }
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKAnswerFormat? {
        
        guard let stepDescriptor = RSEnhancedScaleStepDescriptor(json: jsonObject) else {
            return nil
        }

        return RSEnhancedScaleAnswerFormat(
            maximumValue: stepDescriptor.maximumValue,
            minimumValue: stepDescriptor.minimumValue,
            defaultValue: stepDescriptor.defaultValue,
            stepValue: stepDescriptor.stepValue,
            vertical: stepDescriptor.vertical,
            maxValueLabel: stepDescriptor.maximumValueLabel,
            minValueLabel: stepDescriptor.minimumValueLabel,
            maximumValueDescription: stepDescriptor.maximumValueDescription,
            neutralValueDescription: stepDescriptor.neutralValueDescription,
            minimumValueDescription: stepDescriptor.minimumValueDescription
        )
        
    }
    
    open func generateSteps(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper, identifierPrefix: String) -> [ORKStep]? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper) as? RSEnhancedScaleAnswerFormat,
            let stepDescriptor = RSEnhancedScaleStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let identifier = "\(identifierPrefix).\(stepDescriptor.identifier)"
        
        let step = RSEnhancedScaleStep(identifier: identifier, answerFormat: answerFormat)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
        
        if let stateHelper = helper.stateHelper,
            let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let stateHelper = helper.stateHelper,
            let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        step.isOptional = stepDescriptor.optional
        return [step]
        
    }

}
