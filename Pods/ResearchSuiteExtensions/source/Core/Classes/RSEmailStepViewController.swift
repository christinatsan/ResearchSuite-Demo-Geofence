//
//  RSEmailStepViewController.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit
import MessageUI

open class RSEmailStepViewController: RSQuestionViewController, MFMailComposeViewControllerDelegate {

    open var emailSent: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let emailStep = self.step as? RSEmailStep else {
            return
        }
        
        self.setContinueButtonTitle(title: emailStep.buttonText)
        self.emailSent = false
    }
    
    func showErrorMessage(emailStep: RSEmailStep) {
        DispatchQueue.main.async {
            self.emailSent = true
            self.setContinueButtonTitle(title: "Continue")
            let alertController = UIAlertController(title: "Email failed", message: emailStep.errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func generateMailLink(emailStep: RSEmailStep) -> URL? {
        let recipients: String = emailStep.recipientAddreses.joined(separator: ",")
        
        var emailLink = "mailto:\(recipients)"
        
        let params: [String: String] = {
            var paramDict: [String: String] = [:]
            if let subject = emailStep.messageSubject?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                paramDict["Subject"] = subject
            }
            
            if let body = emailStep.messageBody?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                paramDict["Body"] = body
            }
            
            return paramDict
        }()
        
        if params.count > 0 {
            let paramStrings: [String] = params.map({ (pair) -> String in
                return "\(pair.0)=\(pair.1)"
            })
            
            let paramsString = paramStrings.joined(separator: "&")
            emailLink = "\(emailLink)?\(paramsString)"
        }
        
        return URL(string: emailLink)
    }

    func composeMail(emailStep: RSEmailStep) {
        
        
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(emailStep.recipientAddreses)
            if let subject = emailStep.messageSubject {
                composeVC.setSubject(subject)
            }
            
            if let body = emailStep.messageBody {
                composeVC.setMessageBody(body, isHTML: emailStep.bodyIsHTML)
            }
            else {
                composeVC.setMessageBody("", isHTML: false)
            }
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            
            if let url = self.generateMailLink(emailStep: emailStep),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                        if success {
                            self.emailSent = true
                            self.notifyDelegateAndMoveForward()
                        }
                        
                        else {
                            self.showErrorMessage(emailStep: emailStep)
                        }
                    })
                } else {
                    // Fallback on earlier versions
                    let success = UIApplication.shared.openURL(url)
                    if success {
                        self.emailSent = true
                        self.notifyDelegateAndMoveForward()
                    }
                    else {
                        self.showErrorMessage(emailStep: emailStep)
                    }
                }
            }
            else {
                self.showErrorMessage(emailStep: emailStep)
            }

        }
        
    }
    
    override open func continueTapped(_ sender: Any) {
        
        if self.emailSent {
            self.notifyDelegateAndMoveForward()
        }
        else if let emailStep = self.step as? RSEmailStep {
            //load email
            
            self.composeMail(emailStep: emailStep)
            
        }
        
    }
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result != .cancelled && result != .failed {
            self.emailSent = true
            self.notifyDelegateAndMoveForward()
        }
        else {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
