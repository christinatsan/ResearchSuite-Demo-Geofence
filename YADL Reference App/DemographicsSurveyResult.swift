//
//  DemographicsSurveyResult.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 3/28/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
import ResearchSuiteResultsProcessor
import Gloss
//import OMHClient
import LS2SDK

open class DemographicsSurveyResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
            "DemographicsSurvey"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    
    public static func transform(taskIdentifier: String, taskRunUUID: UUID, parameters: [String : AnyObject]) -> RSRPIntermediateResult? {
        
        let gender: [String]? = {
            guard let stepResult = parameters["gender"],
            let result = stepResult.firstResult as? ORKChoiceQuestionResult,
                let choices = result.choiceAnswers as? [String] else {
                    return nil
            }
            return choices
        }()
        
        let age: NSNumber? = {
            guard let stepResult = parameters["age"],
                let result = stepResult.firstResult as? ORKNumericQuestionResult,
                let choice = result.numericAnswer else {
                    return nil
            }
            return choice
        }()
  
        let zipcode: String? = {
            guard let stepResult = parameters["zip_code"],
                let result = stepResult.firstResult as? ORKTextQuestionResult,
                let choice = result.textAnswer else {
                    return nil
            }
            return choice
        }()
       
        let survey = DemographicsSurveyResult(uuid: UUID(), taskIdentifier: taskIdentifier, taskRunUUID: taskRunUUID,
                                              gender:gender, age:age, zipcode:zipcode)
        return survey
        
    }
    
    public let gender: [String]?
    public let age: NSNumber?
    public let zipcode: String?
    
    public init(uuid: UUID, taskIdentifier:String, taskRunUUID:UUID, gender:[String]?, age:NSNumber?, zipcode:String?){
        self.gender = gender
        self.age = age
        self.zipcode = zipcode
        
        super.init(type:"DemographicsSurvey",
                   uuid:uuid,
                   taskIdentifier:taskIdentifier,
                   taskRunUUID: taskRunUUID)
    }
    
    
    
    
}
