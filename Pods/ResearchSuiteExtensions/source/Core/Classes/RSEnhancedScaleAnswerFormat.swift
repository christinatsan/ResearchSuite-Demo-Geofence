//
//  RSEnhancedScaleAnswerFormat.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 3/26/18.
//

import UIKit
import ResearchKit

open class RSEnhancedScaleAnswerFormat: ORKScaleAnswerFormat {
    
    open let maxValueLabel: String?
    open let minValueLabel: String?
    open let neutralValueDescription: String?
    
    public init(
        maximumValue: Int,
        minimumValue: Int,
        defaultValue: Int,
        stepValue: Int,
        vertical: Bool,
        maxValueLabel: String?,
        minValueLabel: String?,
        maximumValueDescription: String?,
        neutralValueDescription: String?,
        minimumValueDescription: String?
        ) {
        self.maxValueLabel = maxValueLabel
        self.minValueLabel = minValueLabel
        self.neutralValueDescription = neutralValueDescription
        
        super.init(
            maximumValue: maximumValue,
            minimumValue: minimumValue,
            defaultValue: defaultValue,
            step: stepValue,
            vertical: vertical,
            maximumValueDescription: maximumValueDescription,
            minimumValueDescription: minimumValueDescription
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
