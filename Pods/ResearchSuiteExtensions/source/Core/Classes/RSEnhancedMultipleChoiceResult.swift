//
//  RSEnhancedMultipleChoiceResult.swift
//  Pods
//
//  Created by James Kizer on 4/10/17.
//
//

import UIKit
import ResearchKit
import Gloss

public struct RSEnahncedMultipleChoiceSelection: JSONEncodable {
    
    
    public let identifier: String
    public let value: NSCoding & NSCopying & NSObjectProtocol
    public let auxiliaryResult: ORKResult?
    
    public var description: String {
        return "\(value)"
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "identifier" ~~> self.identifier,
            "value" ~~> self.value,
            "auxiliaryResult" ~~> self.auxiliaryResult
            ])
    }
}

open class RSEnhancedMultipleChoiceResult: ORKResult {
    
    open var choiceAnswers: [RSEnahncedMultipleChoiceSelection]?
    
    open func choiceAnswer(for identifier: String) -> RSEnahncedMultipleChoiceSelection? {
        guard let choiceAnswers = self.choiceAnswers else {
            return nil
        }
        
        return choiceAnswers.filter({ $0.identifier == identifier }).first
    }
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let obj = super.copy(with: zone)
        if let choiceResult = obj as? RSEnhancedMultipleChoiceResult,
                let choiceAnswers = self.choiceAnswers {
            choiceResult.choiceAnswers = choiceAnswers
            return choiceResult
        }
        return obj
    }
    
    override open var description: String {
        //let answers: [String] = choiceAnswers!.map { $0.description }
        let answers: [String] = choiceAnswers != nil ? choiceAnswers!.map { $0.description } : [String]()
        
        if answers.count > 0 {
            var temp = super.description + "[" + answers.reduce("\n", { (acc, answer) -> String in
                return acc + answer + "\n"
            })
            
            return temp + "]"
//            return super.description + "[" + answers.reduce("\n", { (acc, answer) -> String in
//                return acc + answer + "\n"
//            }) + "]"
        }
        else {
            return super.description + "[]"
        }
    }
    
}
