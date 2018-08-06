//
//  RSEnhancedBaseStepGenerator.swift
//  Pods
//
//  Created by James Kizer on 8/6/17.
//
//

import UIKit
import ResearchSuiteTaskBuilder
import Gloss
import SwiftyMarkdown
import Mustache

public extension RSTBBaseStepGenerator {
    
    public func registerFormatters(template: Template) {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        template.register(percentFormatter,  forKey: "percent")
        
        let timeInterval3Decimal = Filter { (timeInterval: TimeInterval?) in
            guard let timeInterval = timeInterval else {
                // No value, or not a TimeInterval: return nil.
                // We could throw an error as well.
                return nil
            }
            
            let timeIntervalFormatter = NumberFormatter()
            timeIntervalFormatter.numberStyle = .decimal
            timeIntervalFormatter.maximumFractionDigits = 3
            timeIntervalFormatter.minimumFractionDigits = 3
            
            guard let timeIntervalString = timeIntervalFormatter.string(for: timeInterval) else {
                return nil
            }
            
            // Return the result
            return "\(timeIntervalString) seconds"
        }
        
        template.register(timeInterval3Decimal,  forKey: "timeInterval3Decimal")
        
        let timeInterval2Decimal = Filter { (timeInterval: TimeInterval?) in
            guard let timeInterval = timeInterval else {
                // No value, or not a TimeInterval: return nil.
                // We could throw an error as well.
                return nil
            }
            
            let timeIntervalFormatter = NumberFormatter()
            timeIntervalFormatter.numberStyle = .decimal
            timeIntervalFormatter.maximumFractionDigits = 2
            timeIntervalFormatter.minimumFractionDigits = 2
            
            guard let timeIntervalString = timeIntervalFormatter.string(for: timeInterval) else {
                return nil
            }
            
            // Return the result
            return "\(timeIntervalString) seconds"
        }
        
        template.register(timeInterval2Decimal,  forKey: "timeInterval2Decimal")
        
    }
    
    public func generateAttributedString(descriptor: RSTemplatedTextDescriptor, stateHelper: RSTBStateHelper, defaultAttributes: [String : Any]? = nil) -> NSAttributedString? {

        let pairs: [(String, Any)] = descriptor.arguments.flatMap { (pair) -> (String, Any)? in
            guard let value: Any = stateHelper.valueInState(forKey: pair.value) else {
                return nil
            }
            
            return (pair.key, value)
        }
        
        let arguments: [String: Any] = Dictionary.init(uniqueKeysWithValues: pairs)
        
        var renderedString: String?
        //check for mismatch in argument length
        guard descriptor.arguments.count == arguments.count else {
            return nil
        }
        
        //then pass through handlebars
        do {
            let template = try Template(string: descriptor.template)
            self.registerFormatters(template: template)
            renderedString = try template.render(arguments)
        }
        catch let error {
            return nil
        }
        
        guard let markdownString = renderedString else {
            return nil
        }
        
        //finally through markdown -> NSAttributedString
        //let's make Body the same as ORKLabel
        //let's adjust headers based on other labels too
        let md = SwiftyMarkdown(string: markdownString)
//        md.h1.fontName = UIFont.preferredFont(forTextStyle: .title1).fontName
        
        let h1Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 35.0, weight: UIFont.Weight.light)
        
        md.h1.fontSize = h1Font.pointSize
        md.h1.fontName = h1Font.fontName
        
        let h2Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 32.0, weight: UIFont.Weight.light)
        
        md.h2.fontSize = h2Font.pointSize
        md.h2.fontName = h2Font.fontName
        
        let h3Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 28.0)
        
        md.h3.fontSize = h3Font.pointSize
        md.h3.fontName = h3Font.fontName
        
        let h4Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 24.0)
        
        md.h4.fontSize = h4Font.pointSize
        md.h4.fontName = h4Font.fontName
        
        let h5Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 20.0)
        
        md.h5.fontSize = h5Font.pointSize
        md.h5.fontName = h5Font.fontName
        
        let h6Font = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.subheadline, defaultSize: 15.0, typeAdjustment: 17.0)
        
        md.h6.fontSize = h6Font.pointSize
        md.h6.fontName = h6Font.fontName
        
        let bodyFont = RSFonts.computeFont(startingTextStyle: UIFontTextStyle.body, defaultSize: 17.0, typeAdjustment: 14.0)
        
        md.body.fontSize = bodyFont.pointSize
        md.body.fontName = bodyFont.fontName
        
        
        let attributedString = md.attributedString()
        
        return attributedString
    }

}
