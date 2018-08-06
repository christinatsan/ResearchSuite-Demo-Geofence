//
//  DefaultRawOMHDatapoint.swift
//  YADL Reference App
//
//  Created by Christina Tsangouri on 3/28/18.
//  Copyright © 2018 Christina Tsangouri. All rights reserved.
//

//import Foundation
//import OMHClient
//
//open class DefaultRawOMHDatapoint: OMHDataPointBuilder{
//    
//    public var dataPointID: String {
//        return self.datapoint.dataPointID
//    }
//    
//    public var schema: OMHSchema {
//        return self.datapoint.schema
//    }
//    
//    public var acquisitionSourceName: String {
//        return self.datapoint.acquisitionSourceName
//    }
//    
//    public var acquisitionSourceCreationDateTime: Date {
//        let dateNow = Date()
//        return dateNow
//    }
//    
//    public var acquisitionModality: OMHAcquisitionProvenanceModality {
//        return self.datapoint.acquisitionModality
//    }
//    
//    public var body: [String : Any] {
//        return self.datapoint.body
//    }
//    
//    let datapoint: OMHDataPointBuilder
//    
//    public init(datapoint: OMHDataPointBuilder) {
//        self.datapoint = datapoint
//    }
//}
