//
//  LoginViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 3/28/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import LS2SDK


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let manager:LS2Manager = (UIApplication.shared.delegate! as! AppDelegate).ls2Manager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 0.44, green: 0.66, blue: 0.86, alpha: 1.0)
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = color.cgColor
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
        self.passwordText.delegate = self
        self.passwordText.returnKeyType = .done
        self.usernameText.delegate = self
        self.passwordText.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        if (passwordText.text?.isEmpty)! || (usernameText.text?.isEmpty)! {
            // make message to fill fields
        }
        else {
            
            self.login()
            
        }
        
    }
    
    private func login() {
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.transition(toRootViewController: vc!, animated: true)
        
//        if manager.isSignedIn{
//            let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
//            let vc = storyboard.instantiateInitialViewController()
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.transition(toRootViewController: vc!, animated: true)
//        }
//        else {
//            manager.signIn(username: usernameText.text!, password: passwordText.text!, completion: { (error) in
//                if error == nil {
//                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard(name: "Onboarding", bundle: Bundle.main)
//                        let vc = storyboard.instantiateInitialViewController()
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.transition(toRootViewController: vc!, animated: true)
//                    }
//                }
//                else {
//                    NSLog(String(describing:error))
//                }
//
//            })
//        }
        
    }
    
}

