//
//  LS2BackEnd.swift
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
import ResearchSuiteResultsProcessor

open class LS2BackEnd: RSRPBackEnd {
    
    let ls2Mananager: LS2Manager
    let transformers: [LS2IntermediateDatapointTranformer.Type]
    
    public init(ls2Mananager: LS2Manager,
                transformers: [LS2IntermediateDatapointTranformer.Type] = [LS2DefaultTransformer.self]) {
        
        self.ls2Mananager = ls2Mananager
        self.transformers = transformers
    }
    
    open func add(intermediateResult: RSRPIntermediateResult) {

        for transformer in self.transformers {
            let additionalMetadata: [String: Any]? = {
                if let closure = self.getAdditionalMetadata {
                    return closure()
                }
                else {
                    return nil
                }
            }()
            
            if let convertible: LS2DatapointConvertible = transformer.transform(intermediateResult: intermediateResult, additionalMetadata: additionalMetadata),
                let datapoint = convertible.toDatapoint(builder: LS2ConcreteDatapoint.self) as? LS2ConcreteDatapoint {
                
                //submit data point
//                self.ls2Mananager.addDatapoint(datapoint: datapoint) { (error) in
//
//                }
                
                self.ls2Mananager.addDatapoint(datapoint: datapoint) { (error) in
                    
                    
                    
                }
                
            }
        }
        
    }
    
    open var getAdditionalMetadata: (() -> [String: Any]?)?
    
}
