//
//  LS2ParticipantAccountGeneratorStep.swift
//  LS2SDK
//
//  Created by James Kizer on 3/23/18.
//
//
// Copyright 2018, Curiosity Health Company
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import ResearchSuiteExtensions

open class LS2ParticipantAccountGeneratorStep: RSStep {
    
    override open func stepViewControllerClass() -> AnyClass {
        return LS2ParticipantAccountGeneratorStepViewController.self
    }
    
    public var buttonText: String? = nil
    public var viewControllerDidLoad: ((UIViewController) -> ())?
    
    public let manager: LS2Manager
    public let participantAccountGeneratorCredentials: LS2ParticipantAccountGeneratorCredentials
    
    public init(identifier: String,
                title: String? = nil,
                text: String? = nil,
                buttonText: String? = nil,
                manager: LS2Manager,
                participantAccountGeneratorCredentials: LS2ParticipantAccountGeneratorCredentials) {
        
        let title = title ?? "Log in"
        let text = text ?? "Please log in"
        
        self.manager = manager
        self.participantAccountGeneratorCredentials = participantAccountGeneratorCredentials
        
        super.init(identifier: identifier)
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
