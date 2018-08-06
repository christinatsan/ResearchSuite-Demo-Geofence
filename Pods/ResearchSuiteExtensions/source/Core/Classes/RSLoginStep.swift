//
//  RSLoginStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 12/26/17.
//

import UIKit
import ResearchKit

open class RSLoginStep: ORKFormStep {
    
    public static let RSLoginStepIdentity = "RSLoginStepIdentity"
    public static let RSLoginStepPassword = "RSLoginStepPassword"
    
    static public func usernameAnswerFormat() -> ORKTextAnswerFormat {
        let answerFormat = ORKTextAnswerFormat()
        answerFormat.keyboardType = UIKeyboardType.emailAddress
        answerFormat.multipleLines = false
        answerFormat.spellCheckingType = UITextSpellCheckingType.no
        answerFormat.autocapitalizationType = UITextAutocapitalizationType.none;
        answerFormat.autocorrectionType = UITextAutocorrectionType.no;
        
        return answerFormat
    }
    
    static public func passwordAnswerFormat() -> ORKTextAnswerFormat {
        let answerFormat = ORKTextAnswerFormat()
        
        answerFormat.keyboardType = UIKeyboardType.default
        answerFormat.isSecureTextEntry = true
        answerFormat.multipleLines = false
        answerFormat.spellCheckingType = UITextSpellCheckingType.no
        answerFormat.autocapitalizationType = UITextAutocapitalizationType.none;
        answerFormat.autocorrectionType = UITextAutocorrectionType.no;
        
        return answerFormat
    }
    
    
    open override func stepViewControllerClass() -> AnyClass {
        return self.loginViewControllerClass
    }
    
    open var loginViewControllerClass: AnyClass!
    
    open var loginViewControllerDidLoad: ((UIViewController) -> ())?
    
    var loginButtonTitle: String!
    var forgotPasswordButtonTitle: String?
    
    public init(identifier: String,
                title: String?,
                text: String?,
                identityFieldName: String = "Username",
                identityFieldAnswerFormat: ORKAnswerFormat = RSLoginStep.usernameAnswerFormat(),
                passwordFieldName: String = "Password",
                passwordFieldAnswerFormat: ORKAnswerFormat = RSLoginStep.passwordAnswerFormat(),
                loginViewControllerClass: AnyClass = RSLoginStepViewController.self,
                loginViewControllerDidLoad: ((UIViewController) -> ())? = nil,
                loginButtonTitle: String = "Login",
                forgotPasswordButtonTitle: String?) {
        
        super.init(identifier: identifier, title: title, text: text)
        
        let identityItem = ORKFormItem(identifier: RSLoginStep.RSLoginStepIdentity,
                                       text: identityFieldName,
                                       answerFormat: identityFieldAnswerFormat,
                                       optional: false)
        
        let passwordItem = ORKFormItem(identifier: RSLoginStep.RSLoginStepPassword,
                                       text: passwordFieldName,
                                       answerFormat: passwordFieldAnswerFormat,
                                       optional: false)
        
        self.formItems = [identityItem, passwordItem]
        
        
        self.loginButtonTitle = loginButtonTitle
        
        self.forgotPasswordButtonTitle = forgotPasswordButtonTitle
        
        self.loginViewControllerClass = loginViewControllerClass
        self.loginViewControllerDidLoad = loginViewControllerDidLoad
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
