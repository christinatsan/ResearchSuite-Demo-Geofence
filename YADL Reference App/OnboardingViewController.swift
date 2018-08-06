//
//  YADLOnboardingViewController.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 11/6/17.
//  Copyright © 2017 Christina Tsangouri. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import UserNotifications
import ResearchSuiteAppFramework


class OnboardingViewController: UIViewController {
    
    let kActivityIdentifiers = "activity_identifiers"
    

    var store: RSStore!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var notifItem: RSAFScheduleItem!
//    var fullAssessmentItem: RSAFScheduleItem!
//    var spotAssessmentItem: RSAFScheduleItem!
//    var pamAssessmentItem: RSAFScheduleItem!
//    var demographicsAssessmentItem: RSAFScheduleItem!
    var locationAssessmentItem: RSAFScheduleItem!
    var resultAddressWork : String = ""
    var resultAddressHome : String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.store = RSStore()

 
    }

    override func viewDidAppear(_ animated: Bool) {
                let shouldSetLocation = self.store.valueInState(forKey: "shouldDoLocation") as! Bool
        
        if(shouldSetLocation){
            self.notifItem = AppDelegate.loadScheduleItem(filename: "LocationSurvey.json")
            self.launchActivity(forItem: (self.notifItem)!)
        }
        
        
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
            if reason == ORKTaskViewControllerFinishReason.completed {
                let taskResult = taskViewController.result
                appDelegate.resultsProcessor.processResult(taskResult: taskResult, resultTransforms: item.resultTransforms)
                
                if(item.identifier == "location_survey"){
                    
                    // SET WORK LOCATION
                    
                    self?.store.set(value: false as NSSecureCoding, key: "shouldDoLocation")
                    
                    let resultWork = taskResult.stepResult(forStepIdentifier: "work_location_step")
                    let locationAnswerWork = resultWork?.firstResult as? ORKLocationQuestionResult
                    let resultCoordWork = locationAnswerWork?.locationAnswer?.coordinate
                    let resultRegionWork = locationAnswerWork?.locationAnswer?.region
                    let resultDictionaryWork = locationAnswerWork?.locationAnswer?.addressDictionary
                    
                    self?.resultAddressWork = ""
                    var resultAddressPartsWork : [String] = []
                    
                    if resultDictionaryWork?.index(forKey: "Name") != nil {
                        let name = resultDictionaryWork?["Name"] as! String
                        resultAddressPartsWork.append(name)
                    }
                    if resultDictionaryWork?.index(forKey: "City") != nil {
                        let city = resultDictionaryWork?["City"] as! String
                        resultAddressPartsWork.append(",")
                        resultAddressPartsWork.append(" ")
                        resultAddressPartsWork.append(city)
                    }
                    if resultDictionaryWork?.index(forKey: "State") != nil {
                        let state = resultDictionaryWork?["State"] as! String
                        resultAddressPartsWork.append(",")
                        resultAddressPartsWork.append(" ")
                        resultAddressPartsWork.append(state)
                    }
                    if resultDictionaryWork?.index(forKey: "ZIP") != nil {
                        let zip = resultDictionaryWork?["ZIP"] as! String
                        resultAddressPartsWork.append(",")
                        resultAddressPartsWork.append(" ")
                        resultAddressPartsWork.append(zip)
                        
                    }
                    
                    for i in resultAddressPartsWork {
                        self?.resultAddressWork = (self?.resultAddressWork)! + i
                    }
                    
                    self?.store.setValueInState(value: self!.resultAddressWork as NSSecureCoding , forKey: "work_location")
                    
                    self?.store.setValueInState(value: resultCoordWork!.latitude as NSSecureCoding, forKey: "work_coordinate_lat")
                    self?.store.setValueInState(value: resultCoordWork!.longitude as NSSecureCoding, forKey: "work_coordinate_long")
                    
                    // SET HOME LOCATION
                    
                    let resultHome = taskResult.stepResult(forStepIdentifier: "home_location_step")
                    let locationAnswerHome = resultHome?.firstResult as? ORKLocationQuestionResult
                    let resultCoordHome = locationAnswerHome?.locationAnswer?.coordinate
                    let resultRegionHome = locationAnswerHome?.locationAnswer?.region
                    let resultDictionaryHome = locationAnswerHome?.locationAnswer?.addressDictionary
                    
                    self?.resultAddressHome = ""
                    var resultAddressPartsHome : [String] = []
                    
                    if resultDictionaryHome?.index(forKey: "Name") != nil {
                        let name = resultDictionaryHome?["Name"] as! String
                        resultAddressPartsHome.append(name)
                    }
                    if resultDictionaryHome?.index(forKey: "City") != nil {
                        let city = resultDictionaryHome?["City"] as! String
                        resultAddressPartsHome.append(",")
                        resultAddressPartsHome.append(" ")
                        resultAddressPartsHome.append(city)
                    }
                    if resultDictionaryHome?.index(forKey: "State") != nil {
                        let state = resultDictionaryHome?["State"] as! String
                        resultAddressPartsHome.append(",")
                        resultAddressPartsHome.append(" ")
                        resultAddressPartsHome.append(state)
                    }
                    if resultDictionaryHome?.index(forKey: "ZIP") != nil {
                        let zip = resultDictionaryHome?["ZIP"] as! String
                        resultAddressPartsHome.append(",")
                        resultAddressPartsHome.append(" ")
                        resultAddressPartsHome.append(zip)
                        
                    }
                    
                    
                    for i in resultAddressPartsHome {
                        self?.resultAddressHome = (self?.resultAddressHome)! + i
                    }
                    
                    self?.store.setValueInState(value: self!.resultAddressHome as NSSecureCoding , forKey: "home_location")
                    
                    self?.store.setValueInState(value: resultCoordHome!.latitude as NSSecureCoding, forKey: "home_coordinate_lat")
                    self?.store.setValueInState(value: resultCoordHome!.longitude as NSSecureCoding, forKey: "home_coordinate_long")
                    
                }
            
            }
            
            self?.dismiss(animated: true, completion: {
                

                if (item.identifier == "location_survey"){
                    appDelegate.updateMonitoredRegions(regionChanged: "both")
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let vc = storyboard.instantiateInitialViewController()
                    appDelegate.transition(toRootViewController: vc!, animated: true)
                }
                
                

                
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
