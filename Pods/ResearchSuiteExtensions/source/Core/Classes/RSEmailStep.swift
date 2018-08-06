//
//  RSEmailStep.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit

open class RSEmailStep: RSStep {

    open let buttonText: String
    open let recipientAddreses: [String]
    open let messageSubject: String?
    open let messageBody: String?
    open let errorMessage: String?
    open let bodyIsHTML: Bool
    
    public init(
        identifier: String,
        recipientAddreses: [String],
        messageSubject: String?,
        messageBody: String?,
        bodyIsHTML: Bool,
        errorMessage: String,
        buttonText: String
    ) {
        self.buttonText = buttonText
        self.recipientAddreses = recipientAddreses
        self.messageSubject = messageSubject
        self.messageBody = messageBody
        self.bodyIsHTML = bodyIsHTML
        self.errorMessage = errorMessage
        super.init(identifier: identifier)
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func stepViewControllerClass() -> AnyClass {
        return RSEmailStepViewController.self
    }
    
}
