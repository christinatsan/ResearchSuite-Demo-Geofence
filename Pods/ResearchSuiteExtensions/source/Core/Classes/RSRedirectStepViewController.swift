//
//  RSRedirectStepViewController.swift
//  Pods
//
//  Created by James Kizer on 7/29/17.
//
//

import UIKit
import ResearchKit

open class RSRedirectStepViewController: RSQuestionViewController {
    
    open var redirectDelegate: RSRedirectStepDelegate?
    open var logInSuccessful: Bool? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let step = self.step as? RSRedirectStep {
            self.setContinueButtonTitle(title: step.buttonText)
            self.redirectDelegate = step.delegate
        }
        
        self.redirectDelegate?.redirectViewControllerDidLoad(viewController: self)
        
    }

    override open func continueTapped(_ sender: Any) {
        
        self.redirectDelegate?.beginRedirect(completion: { (error, errorMessage) in
            
            if error == nil {
                self.logInSuccessful = true
                DispatchQueue.main.async {
                    self.notifyDelegateAndMoveForward()
                }
            }
            else {
                self.logInSuccessful = false
                let message: String = errorMessage ?? "An unknown error occurred"
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Log in failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                        
                    }
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        })
        
    }
    
    override open var result: ORKStepResult? {
        guard let result = super.result else {
            return nil
        }
        
        guard let logInSuccessful = self.logInSuccessful,
            let step = step else {
                return result
        }
        
        let boolResult = ORKBooleanQuestionResult(identifier: step.identifier)
        boolResult.booleanAnswer = NSNumber(booleanLiteral: logInSuccessful)
        
        result.results = [boolResult]
        return result
    }
}
