//
//  YADLViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteAppFramework

class PAMViewController: UIViewController{
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    var store: RSStore!
    let kActivityIdentifiers = "activity_identifiers"
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var pamAssessmentItem: RSAFScheduleItem!
    
    @IBOutlet
    var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.store = RSStore()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let should_do_assessment = self.store.valueInState(forKey: "should_do_pam") as! Bool!
        if (should_do_assessment)! {
            launchPAMAssessment()
        }
        
        

    }

    
    func launchPAMAssessment() {
        self.pamAssessmentItem = AppDelegate.loadScheduleItem(filename: "pam.json")
        self.launchActivity(forItem: pamAssessmentItem)
    }
    

    
    func launchActivity(forItem item: RSAFScheduleItem) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let steps = appDelegate.taskBuilder.steps(forElement: item.activity as JsonElement) else {
                return
        }
        
        let task = ORKOrderedTask(identifier: item.identifier, steps: steps)
        
        let taskFinishedHandler: ((ORKTaskViewController, ORKTaskViewControllerFinishReason, Error?) -> ()) = { [weak self] (taskViewController, reason, error) in
            //when finised, if task was successful (e.g., wasn't canceled)
            //process results
            
            if reason == ORKTaskViewControllerFinishReason.discarded {
                
            }
            
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
                self?.store.setValueInState(value: false as NSSecureCoding, forKey: "should_do_pam")
                
                
            }
            
            self?.dismiss(animated: true, completion: {
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateInitialViewController()
                appDelegate.transition(toRootViewController: vc!, animated: true)
                
            })
        }
        
        let tvc = RSAFTaskViewController(
            activityUUID: UUID(),
            task: task,
            taskFinishedHandler: taskFinishedHandler
        )
        
        self.present(tvc, animated: true, completion: nil)
        
    }
    
    
    
    
    
}

