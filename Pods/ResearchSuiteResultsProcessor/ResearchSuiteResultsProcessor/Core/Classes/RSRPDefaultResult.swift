//
//  RSRPDefaultResult.swift
//  ResearchSuiteResultsProcessor
//
//  Created by James Kizer on 10/19/17.
//

import UIKit
import ResearchKit
import CoreLocation
import Gloss

public protocol RSRPDefaultValueTransformer {
    var defaultValue: AnyObject? { get }
    var defaultSerializedValue: AnyObject? { get }
}

extension RSRPDefaultValueTransformer {
    public var defaultSerializedValue: AnyObject? {
        return self.defaultValue
    }
}

//default results

//ORKScaleQuestionResult
extension ORKScaleQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.scaleAnswer {
            return answer
        }
        return nil
    }
}

extension ORKTextChoice: RSRPDefaultValueTransformer {
    public var defaultValue: AnyObject? {
        return self.value
    }
}

extension ORKChoiceQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answers = self.choiceAnswers {
            return answers as NSArray
        }
        return nil
    }
    
    public var defaultSerializedValue: AnyObject? {
        if let answers = self.choiceAnswers {
            
            let mappedAnswers = answers.flatMap({ (answer) -> AnyObject? in
                
                if let i = answer as? NSNumber {
                    return i
                }
                else if let s = answer as? NSString {
                    return s
                }
                else if let transformable = answer as? RSRPDefaultValueTransformer {
                    return transformable.defaultSerializedValue
                }
                
                assertionFailure("answer is not transformable")
                return answer as AnyObject
                
            })
            
            return mappedAnswers as NSArray
        }
        return nil
    }
}

//ORKBooleanQuestionResult
extension ORKBooleanQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.booleanAnswer {
            return answer
        }
        return nil
    }
    
}


extension ORKTextQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.textAnswer {
            return answer as NSString
        }
        return nil
    }
    
}

//ORKNumericQuestionResult
extension ORKNumericQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.numericAnswer {
            return answer
        }
        return nil
    }
    
}

//ORKTimeOfDayQuestionResult
extension ORKTimeOfDayQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultSerializedValue: AnyObject? {

        let calendar = Calendar(identifier: .gregorian)

        guard let dateComponents = self.dateComponentsAnswer,
            let date = calendar.date(from: dateComponents) else {
                return nil
        }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let timeString = timeFormatter.string(from: date)

        return timeString as NSString
    }
    
    public var defaultValue: AnyObject? {
        
        if let answer = self.dateComponentsAnswer {
            return answer as NSDateComponents
        }
        return nil
    }
}

//ORKTimeIntervalQuestionResult
extension ORKTimeIntervalQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.intervalAnswer {
            return answer
        }
        return nil
    }
}


//ORKDateQuestionResult
extension ORKDateQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.dateAnswer {
            return answer as NSDate
        }
        return nil
    }
    
    public var defaultSerializedValue: AnyObject? {
        if let answer = self.dateAnswer {
            return RSRPDefaultResultHelpers.ISO8601Formatter.string(from: answer) as NSString
        }
        return nil
    }
}


//ORKLocationQuestionResult
extension ORKLocationQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.locationAnswer {
            return CLLocation(latitude: answer.coordinate.latitude, longitude: answer.coordinate.longitude)
        }
        return nil
    }
    
}

//ORKMultipleComponentQuestionResult
extension ORKMultipleComponentQuestionResult: RSRPDefaultValueTransformer {
    
    public var defaultValue: AnyObject? {
        if let answer = self.componentsAnswer {
            return answer as AnyObject
        }
        return nil
    }
    
//    public var defaultSerializedValue: AnyObject? {
//        if let answer = self.dateAnswer {
//            return RSRPDefaultResultHelpers.ISO8601Formatter.string(from: answer) as NSString
//        }
//        return nil
//    }
    
}


public class RSRPDefaultResultHelpers {
    
    public static let ISO8601Formatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    public class func extractResults(parameters: [String : AnyObject], forSerialization: Bool) -> [String: AnyObject]? {
        
        let selector: (RSRPDefaultValueTransformer) -> AnyObject? = {
            if forSerialization { return { $0.defaultSerializedValue } }
            else { return { $0.defaultValue } }
        }()
        
        let resultsPairList: [(String, AnyObject)] = parameters.flatMap { (pair) -> (String, AnyObject)? in
            
            guard let stepResult = pair.value as? ORKStepResult,
                let firstResult = stepResult.firstResult as? RSRPDefaultValueTransformer,
                let resultValue: AnyObject = selector(firstResult) else {
                    return nil
            }
            
            return (pair.key, resultValue)
        }
        
        var resultsMap: [String: AnyObject] = [:]
        
        resultsPairList.forEach { (pair) in
            resultsMap[pair.0] = pair.1
        }
        
        return resultsMap
        
    }
    
    public class func stepResultsSortedByStartDate(parameters: [String : AnyObject]) -> [ORKStepResult] {
        let results: [ORKStepResult] = parameters.flatMap { $0.value as? ORKStepResult }
        let sortedResults: [ORKStepResult] = results.sorted { (firstResult, secondResult) -> Bool in
            //if first result start time is before second result, return true
            return firstResult.startDate <= secondResult.startDate
        }
        
        return sortedResults
    }
    
    public class func startDate(parameters: [String : AnyObject]) -> Date? {
        return stepResultsSortedByStartDate(parameters: parameters).first?.startDate
    }
    
    public class func endDate(parameters: [String : AnyObject]) -> Date? {
        return stepResultsSortedByStartDate(parameters: parameters).last?.endDate
    }

}


