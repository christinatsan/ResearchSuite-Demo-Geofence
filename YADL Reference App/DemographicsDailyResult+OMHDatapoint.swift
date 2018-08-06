//
//  DemographicsDailyResult+OMHDatapoint.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 3/28/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

import Foundation
//import OMHClient
//
//extension DemographicsSurveyResult: OMHDataPointBuilder {
//   
//    open var creationDateTime: Date {
//        return self.startDate ?? Date()
//    }
//    
//    open var dataPointID: String {
//        return self.uuid.uuidString
//    }
//    
//    public var acquisitionModality: OMHAcquisitionProvenanceModality {
//        return .Sensed
//    }
//    
//    public var acquisitionSourceCreationDateTime: Date {
//        return self.startDate!
//    }
//    
//    public var acquisitionSourceName: String {
//        return (Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String)!
//    }
//    
//    open var schema: OMHSchema {
//        return OMHSchema(name: "rs-survey", version: "1.0.0", namespace: "Cornell")
//    }
//    
//    open var body: [String:Any] {
//        var returnBody: [String:Any] = [:]
//        
//        returnBody["gender"] = self.gender
//        returnBody["age"] = self.age
//        returnBody["zipcode"] = self.zipcode
//        
//        return returnBody
//    }
//    
//    
//}
