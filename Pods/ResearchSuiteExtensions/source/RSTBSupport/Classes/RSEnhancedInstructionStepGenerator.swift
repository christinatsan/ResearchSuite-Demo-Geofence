//
//  RSEnhancedInstructionStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import ResearchKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache
import SwiftyGif

open class RSEnhancedInstructionStepGenerator: RSTBBaseStepGenerator {
    
    public init(){}
    
    open var supportedTypes: [String]! {
        return ["RSEnhancedInstructionStep"]
    }

    open func generateStep(type: String, jsonObject: JSON, helper: RSTBTaskBuilderHelper) -> ORKStep? {
        
        guard let stepDescriptor = RSEnhancedInstructionStepDescriptor(json:jsonObject),
            let stateHelper = helper.stateHelper else {
                return nil
        }
        
        let step = RSEnhancedInstructionStep(identifier: stepDescriptor.identifier)
        step.title = stepDescriptor.title
        step.text = stepDescriptor.text
//        step.detailText = stepDescriptor.detailText
        
        if let formattedTitle = stepDescriptor.formattedTitle {
            step.attributedTitle = self.generateAttributedString(descriptor: formattedTitle, stateHelper: stateHelper)
        }
        
        if let formattedText = stepDescriptor.formattedText {
            step.attributedText = self.generateAttributedString(descriptor: formattedText, stateHelper: stateHelper)
        }
        
        if let gifTitle = stepDescriptor.gifTitle,
            let gifURL = Bundle.main.url(forResource: gifTitle, withExtension: nil) {
            
            //get url for local image
            let gif = UIImage(gifName: gifTitle)
            step.gif = gif
            step.gifURL = gifURL
        }
        
        if let gifURLString = stepDescriptor.gifURL,
            let gifURL = URL(string: gifURLString) {
            step.gifURL = gifURL
        }
        
        if let imageTitle = stepDescriptor.imageTitle,
            let image = UIImage(named: imageTitle) {
            step.image = image
        }
        
        step.audioTitle = stepDescriptor.audioTitle
        
        return step
    }
    
    open func processStepResult(type: String,
                                jsonObject: JsonObject,
                                result: ORKStepResult,
                                helper: RSTBTaskBuilderHelper) -> JSON? {
        return nil
    }
    
    

}
