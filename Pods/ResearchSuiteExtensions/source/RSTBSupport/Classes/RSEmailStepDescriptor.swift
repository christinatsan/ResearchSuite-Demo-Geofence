//
//  RSEmailStepDescriptor.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 2/7/18.
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss

open class RSEmailStepDescriptor: RSTBStepDescriptor {
    
    public let buttonText: String?
    public let formattedTitle: RSTemplatedTextDescriptor?
    public let formattedText: RSTemplatedTextDescriptor?
    public let recipientAddreses: [String]
    public let messageSubject: String?
    public let messageBody: String?
    public let bodyIsHTML: Bool
    public let errorMessage: String
    
    required public init?(json: JSON) {
        
        self.buttonText = "buttonText" <~~ json
        self.formattedTitle = "formattedTitle" <~~ json
        self.formattedText = "formattedText" <~~ json
        
        guard let recipientAddreses: [String] = "recipientAddreses" <~~ json else {
            return nil
        }
        
        self.recipientAddreses = recipientAddreses
        self.messageSubject = "messageSubject" <~~ json
        self.messageBody = "messageBody" <~~ json
        self.bodyIsHTML = "bodyIsHTML" <~~ json ?? false
        self.errorMessage = "errorMessage" <~~ json ?? "We encountered an error launching your email client."
        
        super.init(json: json)
    }
    
}
