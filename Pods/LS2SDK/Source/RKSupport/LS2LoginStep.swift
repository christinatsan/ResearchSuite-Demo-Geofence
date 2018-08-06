//
//  LS2LoginStep.swift
//  LS2SDK
//
//  Created by James Kizer on 12/26/17.
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

open class LS2LoginStep: RSLoginStep {
    
    public init(identifier: String,
                title: String? = nil,
                text: String? = nil,
                forgotPasswordButtonTitle: String? = nil,
                ls2Manager: LS2Manager? = nil) {
        
        let didLoad: (UIViewController) -> Void = { viewController in
            
            if let logInVC = viewController as? LS2LoginStepViewController {
                logInVC.ls2Manager = ls2Manager
            }
            
        }
        
        let title = title ?? "Log in"
        let text = text ?? "Please log in"
        
        super.init(identifier: identifier,
                   title: title,
                   text: text,
                   loginViewControllerClass: LS2LoginStepViewController.self,
                   loginViewControllerDidLoad: didLoad,
                   forgotPasswordButtonTitle: forgotPasswordButtonTitle)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
