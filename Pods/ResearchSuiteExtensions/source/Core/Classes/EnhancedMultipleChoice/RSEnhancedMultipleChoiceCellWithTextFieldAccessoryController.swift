//
//  RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/25/18.
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController: RSEnhancedMultipleChoiceBaseCellController, UITextFieldDelegate {
    
    override open class func supports(textChoice: RSTextChoiceWithAuxiliaryAnswer) -> Bool {
        
        switch textChoice.auxiliaryItem?.answerFormat {
            
        case .some(_ as ORKTextAnswerFormat):
            
            return true
            
        case .some(_ as ORKEmailAnswerFormat):
            
            return true
            
        case .some(_ as ORKNumericAnswerFormat):
            return true
            
        default:
            return false
        
        }
    }
    
    open override class func generate(textChoice: RSTextChoiceWithAuxiliaryAnswer, choiceSelection: RSEnahncedMultipleChoiceSelection?, onValidationFailed: ((String) -> ())?, onAuxiliaryItemResultChanged: (() -> ())?) -> RSEnhancedMultipleChoiceCellController? {
        
        return self.init(
            textChoice: textChoice,
            choiceSelection: choiceSelection,
            onValidationFailed: onValidationFailed,
            onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged
        )
    }
    
    var accessoryView: RSEnhancedMultipleChoiceCellTextFieldAccessory?
    
    open override var firstResponderView: UIView? {
        //        assert(self.managedCell != nil)
        return self.accessoryView?.textField
    }
    
    private var currentText: String?
    
    open override func viewForAuxiliaryItem(item: ORKFormItem, cell: RSEnhancedMultipleChoiceCell) -> UIView? {
        
        if let accessoryView = self.accessoryView {
            return accessoryView
        }
        else {
            
            guard let accessoryView = RSEnhancedMultipleChoiceCellTextFieldAccessory.newView() else {
                return nil
            }
            
            switch(self.validatedResult) {
            case .some(let textResult as ORKTextQuestionResult):
                self.currentText = textResult.textAnswer
                
            case .some(let numericResult as ORKNumericQuestionResult):
                if let numericAnswer = numericResult.numericAnswer {
                    self.currentText = String(describing: numericAnswer)
                }
            default:
                break
            }
            
            accessoryView.textLabel.text = item.text
            accessoryView.textField.text = self.currentText
            accessoryView.textField.placeholder = item.placeholder
            accessoryView.textField.delegate = self
            
            switch item.answerFormat {
                
            case .some(let answerFormat as ORKTextAnswerFormat):
                
                
                accessoryView.textField.autocapitalizationType = answerFormat.autocapitalizationType
                accessoryView.textField.autocorrectionType = answerFormat.autocorrectionType
                accessoryView.textField.spellCheckingType = answerFormat.spellCheckingType
                accessoryView.textField.keyboardType = answerFormat.keyboardType
                accessoryView.textField.isSecureTextEntry = answerFormat.isSecureTextEntry
                
            case .some(_ as ORKEmailAnswerFormat):
                
                accessoryView.textField.autocapitalizationType = UITextAutocapitalizationType.none
                accessoryView.textField.autocorrectionType = UITextAutocorrectionType.default
                accessoryView.textField.spellCheckingType = UITextSpellCheckingType.default
                accessoryView.textField.keyboardType = UIKeyboardType.emailAddress
                accessoryView.textField.isSecureTextEntry = false
                
            case .some(_ as ORKNumericAnswerFormat):
                
                accessoryView.textField.autocapitalizationType = UITextAutocapitalizationType.none
                accessoryView.textField.autocorrectionType = UITextAutocorrectionType.default
                accessoryView.textField.spellCheckingType = UITextSpellCheckingType.default
                accessoryView.textField.keyboardType = UIKeyboardType.numberPad
                accessoryView.textField.returnKeyType = .done
                accessoryView.textField.isSecureTextEntry = false

                let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 320, height: 50))
                doneToolbar.barStyle = UIBarStyle.default
                
                let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: accessoryView.textField, action: #selector(UIResponder.resignFirstResponder))
                
                var items = [UIBarButtonItem]()
                items.append(flexSpace)
                items.append(done)
                
                doneToolbar.items = items
                doneToolbar.sizeToFit()
                
                accessoryView.textField.inputAccessoryView = doneToolbar
                
                
            default:
                return nil
                
            }
            
            //we can't set first responder here as this messes up when we browse back to previous screen
            self.accessoryView = accessoryView
            return accessoryView
            
        }
        
    }
    
    //delegate
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
//        self.delegate?.auxiliaryTextFieldDidEndEditing(textField, forCellId: self.identifier)
//        if !self.selected.contains(id) {
//            self.updateUI()
//            return
//        }
        
        assert(self.hasAuxiliaryItem)
        
        if !self.isSelected {
            return
        }
        
        //emtpy should be considered valid in all cases
        if let text = textField.text,
            text.count > 0 {
            
            self.currentText = textField.text
            
            //validate
            //if passes, convert into result
            //otherwise, throw message
            
            if self.validate(text: text) {
                self.validatedResult = self.convertToResult(text: text)
            }
            else {
                self.validatedResult = nil
            }
            
        }
        else {
            
            //clear the
            //is this empty?
//            self.currentText[id] = textField.text
            self.currentText = textField.text
            if !self.isAuxiliaryItemOptional! {
                self.showValidityAlertMessage(message: "The field associated with choice \"\(textChoice.text)\" is required.")
            }
        }
        
//        self.updateUI()
    }
    //delegate
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let startingText = textField.text {
            
            let start = startingText.index(startingText.startIndex, offsetBy: range.location)
            let end = startingText.index(startingText.startIndex, offsetBy: range.location + range.length)
            let stringRange = start..<end
            let text = startingText.replacingCharacters(in: stringRange, with: string)
            let textWithoutNewlines = text.components(separatedBy: CharacterSet.newlines).joined(separator: "")
            
            if self.validateTextForLength(text: textWithoutNewlines) == false {
                //                self.updateUI()
                return false
            }
            
            //set the state of text
            self.currentText = textWithoutNewlines
        }
        //        self.updateUI()
        return true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.currentText = nil
        self.validatedResult = nil
//        self.updateUI()
        return true
       
    }

    func showValidityAlertMessage(message: String) {
        self.onValidationFailed?(message)
    }
    
    func convertToResult(text: String) -> ORKResult? {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat else {
                return nil
        }
        
        switch(answerFormat) {
        case _ as ORKTextAnswerFormat:
            
            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
            result.textAnswer = text
            return result
            
        case _ as ORKEmailAnswerFormat:
            
            let result = ORKTextQuestionResult(identifier: auxItem.identifier)
            result.textAnswer = text
            return result
            
        case let answerFormat as ORKNumericAnswerFormat:
            
            if answerFormat.style == .decimal {
                if let answer = Double(text) {
                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
                    result.numericAnswer = NSNumber(floatLiteral: answer)
                    result.unit = answerFormat.unit
                    return result
                }
            }
            else {
                if let answer = Int(text) {
                    let result = ORKNumericQuestionResult(identifier: auxItem.identifier)
                    result.numericAnswer = NSNumber(integerLiteral: answer)
                    result.unit = answerFormat.unit
                    return result
                }
            }
            return nil
        default:
            return nil
        }
    }
    
    func validate(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat else {
            self.showValidityAlertMessage(message: "An eror occurred")
            return false
        }
        
        return answerFormat.isAnswerValid(with: text)
        
//        switch auxItem.answerFormat {
//
//        case _ as ORKTextAnswerFormat:
//
//            if self.validateTextForLength(text: text) && self.validateTextForRegEx(text: text) {
//                return true
//            }
//            else {
//                self.showValidityAlertMessage(message: "The input is incorrectly formatted")
//                return false
//            }
//
//        case _ as ORKEmailAnswerFormat:
//            if self.validateTextForLength(text: text) && self.validateTextForEmail(text: text) {
//                return true
//            }
//            else {
//                self.showValidityAlertMessage(message: "The input is incorrectly formatted")
//                return false
//            }
//
//        case _ as ORKNumericAnswerFormat:
//            if self.validateNumericTextForRange(text: text) {
//                return true
//            }
//            else {
//                self.showValidityAlertMessage(message: "The input is incorrectly formatted")
//                return false
//            }
//
//        default:
//            self.showValidityAlertMessage(message: "An eror occurred")
//            return false
//
//        }
    }
    
    //MARK: Validation Functions
    //returns true for empty text
    open func validateTextForRegEx(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            let regex = answerFormat.validationRegularExpression,
            let invalidMessage = answerFormat.invalidMessage else {
                return true
        }
        
        let matchCount = regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.count))
        
        if matchCount != 1 {
            self.showValidityAlertMessage(message: invalidMessage)
            return false
        }
        return true
    }
    
    static let EmailValidationRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    open func validateTextForEmail(text: String) -> Bool {
        
        guard let regex = try? NSRegularExpression(pattern: RSEnhancedMultipleChoiceCellWithTextFieldAccessoryController.EmailValidationRegex, options: []) else {
            return false
        }
        
        let matchCount = regex.numberOfMatches(in: text, options: [], range: NSMakeRange(0, text.count))
        return matchCount == 1
        
    }
    
    open func validateTextForLength(text: String) -> Bool {
        
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKTextAnswerFormat,
            answerFormat.maximumLength > 0 else {
                return true
        }
        
        if text.count > answerFormat.maximumLength {
            self.showValidityAlertMessage(message: "Text content exceeding maximum length: \(answerFormat.maximumLength)")
            return false
        }
        else {
            return true
        }
        
    }
    
    open func validateNumericTextForRange(text: String) -> Bool {
        guard let auxItem = self.auxiliaryItem,
            let answerFormat = auxItem.answerFormat as? ORKNumericAnswerFormat else {
                return true
        }
        
        if answerFormat.style == ORKNumericAnswerStyle.decimal,
            let decimalAnswer = Double(text) {
            
            if let minValue = answerFormat.minimum?.doubleValue,
                decimalAnswer < minValue {
                self.showValidityAlertMessage(message: "\(decimalAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.doubleValue,
                decimalAnswer > maxValue {
                self.showValidityAlertMessage(message: "\(decimalAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else if answerFormat.style == ORKNumericAnswerStyle.integer,
            let integerAnswer = Int(text)  {
            
            if let minValue = answerFormat.minimum?.intValue,
                integerAnswer < minValue {
                self.showValidityAlertMessage(message: "\(integerAnswer) is less than the minimum allowed value \(minValue).")
                return false
            }
            
            if let maxValue = answerFormat.maximum?.intValue,
                integerAnswer > maxValue {
                self.showValidityAlertMessage(message: "\(integerAnswer) is more than the maximum allowed value \(maxValue).")
                return false
            }
            
            return true
        }
        else {
            return false
        }
    }
    
}
