//
//  RSEnhancedMultipleChoiceStepViewController.swift
//  Pods
//
//  Created by James Kizer on 4/8/17.
//
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceStepViewController: RSQuestionTableViewController {

    var enhancedMultiChoiceStep: RSEnhancedMultipleChoiceStep!
    
    var cellControllerMap: [Int: RSEnhancedMultipleChoiceCellController]!
    
    var selected: Set<Int> {
        
        let selectedControllers: [Int: RSEnhancedMultipleChoiceCellController]  = self.cellControllerMap.filter { (pair) -> Bool in
            return pair.1.isSelected
        }
        
        return Set(selectedControllers.keys)
        
    }
    
    var auxiliaryResultOptional: Set<Int>! {
        
        let selectedControllers: [Int: RSEnhancedMultipleChoiceCellController]  = self.cellControllerMap.filter { (pair) -> Bool in
            
            if let auxItem = pair.1.auxiliaryItem {
                return auxItem.isOptional
            }
            else {
                return true
            }
            
        }
        
        return Set(selectedControllers.keys)
    
    }

    convenience init(step: ORKStep?) {
        self.init(step: step, result: nil)
    }
    
    
    
    func generateCellController(for textChoice: RSTextChoiceWithAuxiliaryAnswer, choiceSelection: RSEnahncedMultipleChoiceSelection?) -> RSEnhancedMultipleChoiceCellController? {
        
        let onValidationFailed: (String) -> () = { [weak self] message in
            self?.showValidityAlertMessage(message: message )
        }
        
        let onAuxiliaryItemResultChanged:(() -> ()) = { [weak self] in
            self?.updateUI()
            self?.cellControllerMap.forEach { (pair) in
                pair.value.setFocused(isFocused: false)
            }
        }
        
        guard let generator = self.enhancedMultiChoiceStep.cellControllerGenerators.first(where: { $0.supports(textChoice: textChoice) }) else {
            return nil
        }
        
        return generator.generate(textChoice: textChoice, choiceSelection: choiceSelection, onValidationFailed: onValidationFailed, onAuxiliaryItemResultChanged: onAuxiliaryItemResultChanged)
    }
    
    convenience init(step: ORKStep?, result: ORKResult?) {
        
        let framework = Bundle(for: RSQuestionTableViewController.self)
        self.init(nibName: "RSQuestionTableViewController", bundle: framework)
        self.step = step
        self.restorationIdentifier = step!.identifier
        
        self.enhancedMultiChoiceStep = step as! RSEnhancedMultipleChoiceStep
        
        
        guard let answerFormat = self.enhancedMultiChoiceStep.answerFormat,
            let textChoices = answerFormat.textChoices as? [RSTextChoiceWithAuxiliaryAnswer] else {
                assertionFailure("Text choices must be of type RSTextChoiceWithAuxiliaryAnswer")
                return
        }
        
        let stepResult: ORKStepResult? = result as? ORKStepResult
        let choiceResult: RSEnhancedMultipleChoiceResult? = stepResult?.results?.first as? RSEnhancedMultipleChoiceResult
        
        var cellControllerMap: [Int: RSEnhancedMultipleChoiceCellController] = [:]
        
        textChoices.enumerated().forEach { offset, textChoice in
            
            cellControllerMap[offset] = self.generateCellController(for: textChoice, choiceSelection: choiceResult?.choiceAnswer(for: textChoice.identifier) )
            
        }
        
        self.cellControllerMap = cellControllerMap
        
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let enhancedMultiWithAccessoryNIB = UINib(nibName: "RSEnhancedMultipleChoiceCell", bundle: Bundle(for: RSEnhancedMultipleChoiceStepViewController.self))
        self.tableView.register(enhancedMultiWithAccessoryNIB, forCellReuseIdentifier: "enhanced_multi_choice")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        // Do any additional setup after loading the view.
        guard let enhancedMultiChoiceStep = step as? RSEnhancedMultipleChoiceStep,
            let answerFormat = enhancedMultiChoiceStep.answerFormat else {
            return
        }
        
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = answerFormat.style == .multipleChoice
        
        self.selected.forEach( { index in
            self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none )
        })
        
        
        self.updateUI()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.visibleCells.forEach { $0.setNeedsLayout() }
    }

    func updateUI() {
        
        if let selectedPaths = self.tableView.indexPathsForSelectedRows,
            selectedPaths.count > 0 {
            
            let invalidCellControllers = self.cellControllerMap.values.filter { $0.isSelected && !$0.isValid }
            
            self.continueButton.isEnabled = invalidCellControllers.count == 0
        }
        else if self.enhancedMultiChoiceStep.allowsEmptySelection {
            self.continueButton.isEnabled = true
        }
        else {
            self.continueButton.isEnabled = false
        }
        
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.enhancedMultiChoiceStep.answerFormat?.textChoices.count ?? 0
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "enhanced_multi_choice"
        guard let cellController = self.cellControllerMap[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RSEnhancedMultipleChoiceCell else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = "Default Cell"
            return cell
        }
        
        
        cellController.configureCell(cell: cell, selected: self.tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false)
        cell.setNeedsLayout()
        return cell
        
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        self.updateUI()

        self.cellControllerMap.forEach { (pair) in
            let focused = pair.key == indexPath.row
            pair.value.setFocused(isFocused: focused)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        tableView.beginUpdates()
        tableView.endUpdates()
        
        self.view.setNeedsLayout()
        self.updateUI()
        
        self.cellControllerMap.forEach { (pair) in
            pair.value.setFocused(isFocused: false)
        }
    }

    override open func clearAnswer() {
        self.cellControllerMap.values.forEach({ $0.clearAnswer() })
    }
    
    override func continueTapped(_ sender: Any) {
//        self.resignFirstResponder()
        self.view.endEditing(true)
        
        if self.tableView.indexPathsForSelectedRows == nil,
            self.enhancedMultiChoiceStep.allowsEmptySelection {
            
            //we allow empty selection
            if let alert = self.enhancedMultiChoiceStep.emptySelectionConfirmationAlert {
                
                let alertVC = UIAlertController(title: alert.title, message: alert.text, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: alert.cancelText, style: .cancel, handler: { _ in
                    
                })
                alertVC.addAction(cancelAction)
                
                let continueAction = UIAlertAction(title: alert.continueText, style: .default, handler: { _ in
                    super.continueTapped(sender)
                })
                alertVC.addAction(continueAction)

                self.present(alertVC, animated: true, completion: nil)
                return
            }
            else {
                super.continueTapped(sender)
                return
            }
            
        }
        
        
        //rules for moving forward
        //For all selected items
        //if the item is optional, it must have no text or there must be a valid result
        //if the item is not optional, there must be a valid result
        
        //get a list of all controllers that are selected AND invalid
        let invalidCellControllers = self.cellControllerMap.filter { (pair) -> Bool in
            return pair.value.isSelected && !pair.value.isValid
        }
        
        if invalidCellControllers.count == 0 {
            super.continueTapped(sender)
        }
        else {
            self.showValidityAlertMessage(message:"One or more fields is invalid")
        }
        
    }
    
    override open var result: ORKStepResult? {
        guard let result = super.result else {
            return nil
        }
        
        let multipleChoiceResult = RSEnhancedMultipleChoiceResult(identifier: self.enhancedMultiChoiceStep.identifier)
        
        let selections = self.cellControllerMap.values.flatMap { (cellController) -> RSEnahncedMultipleChoiceSelection? in
            return cellController.choiceSelection
        }

        multipleChoiceResult.choiceAnswers = selections
        
        result.results = [multipleChoiceResult]
        
        return result
    }
    
    func showValidityAlertMessage(message: String) {
        
        let title = "Invalid value"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }

}
