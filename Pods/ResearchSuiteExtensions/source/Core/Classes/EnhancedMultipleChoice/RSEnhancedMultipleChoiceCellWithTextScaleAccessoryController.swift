//
//  RSEnhancedMultipleChoiceCellWithTextScaleAccessoryController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/25/18.
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceCellWithTextScaleAccessoryController: RSEnhancedMultipleChoiceBaseCellController {
    
    override open class func supports(textChoice: RSTextChoiceWithAuxiliaryAnswer) -> Bool {
        return (textChoice.auxiliaryItem?.answerFormat as? RSEnhancedTextScaleAnswerFormat) != nil
    }

    override open class func generate(textChoice: RSTextChoiceWithAuxiliaryAnswer, choiceSelection: RSEnahncedMultipleChoiceSelection?, onValidationFailed: ((String) -> ())?, onAuxiliaryItemResultChanged: (() -> ())?) -> RSEnhancedMultipleChoiceCellController? {
        
        return self.init(
            textChoice: textChoice,
            choiceSelection: choiceSelection,
            onValidationFailed: onValidationFailed,
            onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
        )
    }
    
    var answerFormat: RSEnhancedTextScaleAnswerFormat {
        return (self.auxiliaryItem?.answerFormat as? RSEnhancedTextScaleAnswerFormat)!
    }

    var accessoryView: RSSliderView?
    
    open override func viewForAuxiliaryItem(item: ORKFormItem, cell: RSEnhancedMultipleChoiceCell) -> UIView? {
        
        if let accessoryView = self.accessoryView {
            return accessoryView
        }
        
        else {
            
            guard let auxItem = self.auxiliaryItem,
                let answerFormat = auxItem.answerFormat as? RSEnhancedTextScaleAnswerFormat,
                let sliderView = RSSliderView.newView(minimumValue: 0, maximumValue: answerFormat.textChoices.count - 1) else {
                    return nil
            }
            
            assert(auxItem == item)
            
            sliderView.minValueLabel.text = answerFormat.minValueLabel
            sliderView.maxValueLabel.text = answerFormat.maxValueLabel
            sliderView.minValueDescriptionLabel.text = answerFormat.minimumValueDescription
            sliderView.neutralValueDescriptionLabel.text = answerFormat.neutralValueDescription
            sliderView.maxValueDescriptionLabel.text = answerFormat.maximumValueDescription
            sliderView.textLabel.text = item.text
            
            //what to do when the values are updated?
            //when the value changes, validate, then
            
            sliderView.onValueChanged = { value in
                
                if value >= 0 && value < answerFormat.textChoices.count {
                    sliderView.currentValueLabel.text = answerFormat.textChoices[value].text
                    let choiceResult = ORKChoiceQuestionResult(identifier: item.identifier)
                    choiceResult.choiceAnswers = [answerFormat.textChoices[value]]
                    self.validatedResult = choiceResult
                }
                else {
                    self.validatedResult = nil
                }

            }
            
            if  let choiceResult = self.validatedResult as? ORKChoiceQuestionResult,
                let choice = choiceResult.choiceAnswers?.first as? ORKTextChoice,
                let index = answerFormat.textChoices.index(of: choice) {
                sliderView.setValue(value: index, animated: false)
            }
            else {
                sliderView.setValue(value: answerFormat.defaultIndex, animated: false)
            }
            
            sliderView.setNeedsLayout()
            
            self.accessoryView = sliderView
            
            return sliderView
            
        }
        
        
        
    }

}
