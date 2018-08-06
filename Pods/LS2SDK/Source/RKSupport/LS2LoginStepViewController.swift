//
//  LS2LoginStepViewController.swift
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

open class LS2LoginStepViewController: RSLoginStepViewController {

    open var ls2Manager: LS2Manager?
    
    open override func loginButtonAction(username: String, password: String, completion: @escaping ActionCompletion) {
        
        if let ls2Manager = self.ls2Manager {
            
            self.isLoading = true
            
            ls2Manager.signIn(username: username, password: password, forceSignIn: true) { (error) in
                
                self.isLoading = false
                
                if error == nil {
                    self.loggedIn = true
                    completion(true)
                }
                else {
                    self.loggedIn = false
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Log in failed", message: "Username / Password are not valid", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        completion(false)
                    }
                    
                }
                
            }
        }
        
        
    }
    
    open override func forgotPasswordButtonAction(completion: @escaping ActionCompletion) {
        
        self.loggedIn = false
        completion(true)
        
    }

}
