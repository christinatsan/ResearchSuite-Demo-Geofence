//
//  PasscodeViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 1/26/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import LS2SDK
import ResearchSuiteAppFramework

class WelcomeViewController: UIViewController {
    
    var signInItem: RSAFScheduleItem!
    var store: RSStore!

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store = RSStore()
        
        let color = UIColor(red: 0.44, green: 0.66, blue: 0.86, alpha: 1.0)
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = color.cgColor
        startButton.layer.cornerRadius = 5
        startButton.clipsToBounds = true
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func startClicked(_ sender: Any) {
        self.launchSignin()
    }
    func launchSignin() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.transition(toRootViewController: vc!, animated: true)
    }
    
 
    


}
