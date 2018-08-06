//
//  LS2ParticipantAccountGeneratorStepGenerator.swift
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
import ResearchSuiteTaskBuilder
import Gloss
import ResearchSuiteExtensions
import ResearchKit

open class LS2ParticipantAccountGeneratorStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "LS2ParticipantAccountGeneratorStep"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = LS2ParticipantAccountGeneratorStepDescriptor(json:jsonObject),
            let stateHelper = helper.stateHelper,
            let manager = stateHelper.objectInState(forKey: "ls2Manager") as? LS2Manager,
            let participantAccountGeneratorCredentials = stateHelper.objectInState(forKey: "ls2ParticipantAccountCredentials") as? LS2ParticipantAccountGeneratorCredentials else {
                return nil
        }
        
        let step = LS2ParticipantAccountGeneratorStep(
            identifier: stepDescriptor.identifier,
            title: stepDescriptor.title,
            text: stepDescriptor.text,
            buttonText: stepDescriptor.buttonText,
            manager: manager,
            participantAccountGeneratorCredentials: participantAccountGeneratorCredentials
        )
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }

}
