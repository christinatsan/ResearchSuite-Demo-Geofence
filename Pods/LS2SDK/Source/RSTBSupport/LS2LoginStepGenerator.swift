//
//  LS2LoginStepGenerator.swift
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

import ResearchSuiteTaskBuilder
import ResearchKit
import Gloss

open class LS2LoginStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    let _supportedTypes = [
        "LS2Login"
    ]
    
    public var supportedTypes: [String]! {
        return self._supportedTypes
    }
    
    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let customStepDescriptor = helper.getCustomStepDescriptor(forJsonObject: jsonObject),
            let manager = helper.stateHelper?.objectInState(forKey: "ls2Manager") as? LS2Manager else {
                return nil
        }
        
        let step = LS2LoginStep(
            identifier: customStepDescriptor.identifier,
            title: customStepDescriptor.title,
            text: customStepDescriptor.text,
            ls2Manager: manager
        )
        
        step.isOptional = false
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
}
