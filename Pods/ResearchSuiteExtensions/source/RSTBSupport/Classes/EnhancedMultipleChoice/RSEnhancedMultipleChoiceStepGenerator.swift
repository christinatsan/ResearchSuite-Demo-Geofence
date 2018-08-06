//
//  RSEnhancedMultipleChoiceStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEnhancedChoiceStepGenerator: RSTBBaseStepGenerator {
    
    //cell controller generators
    var cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]
    
    public init(cellControllerGenerators: [RSEnhancedMultipleChoiceCellControllerGenerator.Type]){
        self.cellControllerGenerators = cellControllerGenerators
    }
    
    open var allowsMultiple: Bool {
        fatalError("abstract class not implemented")
    }
    
    open var supportedTypes: [String]! {
        return nil
    }
    
    public typealias ChoiceItemFilter = ( (RSEnhancedChoiceItemDescriptor) -> (Bool))
    
    open func generateFilter(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ChoiceItemFilter? {
        
        guard let includedValuesKey: String = "filterItemsByValueInListKeyedBy" <~~ jsonObject,
            let stateHelper = helper.stateHelper,
            let includedValues = stateHelper.valueInState(forKey: includedValuesKey) as? [String] else {
                return { choiceItem in
                    return true
                }
        }
        
        guard includedValues.count > 0 else {
            return { choiceItem in
                return true
            }
        }
        
        return { (item: RSEnhancedChoiceItemDescriptor) in
            if let value = item.value as? String {
                return includedValues.contains(where: { (includedValue) -> Bool in
                    return includedValue.hasPrefix(value)
                })
            }
            else {
                return false
            }
        }
        
    }
    
    open func generateChoices(items: [RSEnhancedChoiceItemDescriptor], valueSuffix: String?, shouldShuffle: Bool?, helper: RSTBTaskBuilderHelper) -> [RSTextChoiceWithAuxiliaryAnswer] {
        
        let shuffledItems = items.shuffled(shouldShuffle: shouldShuffle ?? false)
        
        return shuffledItems.map { item in
            
            let value: NSCoding & NSCopying & NSObjectProtocol = ({
                if let suffix = valueSuffix,
                    let stringValue = item.value as? String {
                    return (stringValue + suffix) as NSCoding & NSCopying & NSObjectProtocol
                }
                else {
                    return item.value
                }
            }) ()
            
            let auxiliaryItem: ORKFormItem? = {
                
                guard let auxiliaryItem = item.auxiliaryItem,
                    let stepDescriptor = RSTBStepDescriptor(json: auxiliaryItem),
                    let builder = helper.builder,
                    let answerFormat = builder.generateAnswerFormat(type: stepDescriptor.type, jsonObject: auxiliaryItem, helper: helper) else {
                    return nil
                }

                let formItem = ORKFormItem(
                    identifier: stepDescriptor.identifier,
                    text: stepDescriptor.text,
                    answerFormat: answerFormat,
                    optional: stepDescriptor.optional
                )
                
                formItem.placeholder = "placeholder" <~~ auxiliaryItem
                
                return formItem
                
            }()
            
            return RSTextChoiceWithAuxiliaryAnswer(
                identifier: item.identifier,
                text: item.text,
                detailText: item.detailText,
                value: value,
                exclusive: item.exclusive,
                auxiliaryItem: auxiliaryItem)
        }
    }
    
    open func generateAnswerFormat(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKTextChoiceAnswerFormat? {
        guard let choiceStepDescriptor:RSEnhancedMultipleChoiceStepDescriptor = RSEnhancedMultipleChoiceStepDescriptor(json: jsonObject) else {
            return nil
        }
        
        let filteredItems: [RSEnhancedChoiceItemDescriptor] = {
            
            if let itemFilter = self.generateFilter(type: type, jsonObject: jsonObject, helper: helper) {
                return choiceStepDescriptor.items.filter(itemFilter)
            }
            else {
                return choiceStepDescriptor.items
            }
            
        }()
        
        let choices = self.generateChoices(items: filteredItems, valueSuffix: choiceStepDescriptor.valueSuffix, shouldShuffle: choiceStepDescriptor.shuffleItems, helper: helper)
        
        guard choices.count > 0 else {
            return nil
        }
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormat(
            with: self.allowsMultiple ? ORKChoiceAnswerStyle.multipleChoice : ORKChoiceAnswerStyle.singleChoice,
            textChoices: choices
        )
        
        return answerFormat
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        guard let answerFormat = self.generateAnswerFormat(type: type, jsonObject: jsonObject, helper: helper),
            let stepDescriptor = RSEnhancedMultipleChoiceStepDescriptor(json: jsonObject) else {
                return nil
        }
        
        let step = RSEnhancedMultipleChoiceStep(
            identifier: stepDescriptor.identifier,
            title: stepDescriptor.title,
            text: stepDescriptor.text,
            answer: answerFormat,
            cellControllerGenerators: self.cellControllerGenerators)
        
        if let stateHelper = helper.stateHelper,
            let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let stateHelper = helper.stateHelper,
            let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        step.isOptional = stepDescriptor.optional
        
        if let allowsEmptySelection = stepDescriptor.allowsEmptySelection {
            step.allowsEmptySelection = allowsEmptySelection.allowed
            step.emptySelectionConfirmationAlert = allowsEmptySelection.confirmationAlert
        }
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        
        return nil
    }
    
//    open override func processQuestionResult(type: String, result: ORKQuestionResult, helper: RSTBTaskBuilderHelper) -> JSON? {
//        
//        if let result = result as? ORKChoiceQuestionResult,
//            let choices = result.choiceAnswers as? [NSCoding & NSCopying & NSObjectProtocol] {
//            return [
//                "identifier": result.identifier,
//                "type": type,
//                "answer": choices
//            ]
//        }
//        return  nil
//    }
    
}

open class RSEnhancedSingleChoiceStepGenerator: RSEnhancedChoiceStepGenerator {
    
    override open var supportedTypes: [String]! {
        return ["enhancedSingleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return false
    }
    
}

open class RSEnhancedMultipleChoiceStepGenerator: RSEnhancedChoiceStepGenerator {
    
    override open var supportedTypes: [String]! {
        return ["enhancedMultipleChoiceText"]
    }
    
    override open var allowsMultiple: Bool {
        return true
    }
}
