//
//  LS2DefaultResult.swift
//  LS2SDK
//
//  Created by James Kizer on 4/20/18.
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
import ResearchKit
import Gloss

open class LS2DefaultResult: RSRPIntermediateResult, RSRPFrontEndTransformer {
    
    private static let supportedTypes = [
        "defaultResult"
    ]
    
    public static func supportsType(type: String) -> Bool {
        return self.supportedTypes.contains(type)
    }
    
    public class func transform(taskIdentifier: String, taskRunUUID: UUID, parameters: [String : AnyObject]) -> RSRPIntermediateResult? {
        
        guard let schema: LS2Schema = "schema" <~~ parameters else {
            return nil
        }
        
        guard let resultDict = RSRPDefaultResultHelpers.extractResults(parameters: parameters, forSerialization: true) else {
            return nil
        }
        
        let metadata: JSON? = "metadata" <~~ parameters
        
        let result = LS2DefaultResult(
            uuid: UUID(),
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID,
            schema: schema,
            metadata: metadata,
            resultDict: resultDict
        )
        
        result.startDate = RSRPDefaultResultHelpers.startDate(parameters: parameters)
        result.endDate = RSRPDefaultResultHelpers.endDate(parameters: parameters)
        
        return result
        
    }
    
    public let schema: LS2Schema
    public let resultDict: JSON
    public let metadata: JSON?
    
    public init(
        uuid: UUID,
        taskIdentifier: String,
        taskRunUUID: UUID,
        schema: LS2Schema,
        metadata: JSON? = nil,
        resultDict: JSON
        ) {
        
        self.schema = schema
        self.metadata = metadata
        self.resultDict = resultDict
        
        super.init(
            type: "LS2DefaultResult",
            uuid: uuid,
            taskIdentifier: taskIdentifier,
            taskRunUUID: taskRunUUID
        )
    }
}

extension LS2DefaultResult: LS2DatapointConvertible {
    public func toDatapoint(builder: LS2DatapointBuilder.Type) -> LS2Datapoint? {
        
        let sourceName = LS2AcquisitionProvenance.defaultAcquisitionSourceName
        let creationDate = self.startDate ?? Date()
        let acquisitionSource = LS2AcquisitionProvenance(sourceName: sourceName, sourceCreationDateTime: creationDate, modality: .SelfReported)
        
        let header = LS2DatapointHeader(id: self.uuid, schemaID: self.schema, acquisitionProvenance: acquisitionSource, metadata: self.metadata)
        return builder.createDatapoint(header: header, body: self.resultDict)
        
    }
    
}
