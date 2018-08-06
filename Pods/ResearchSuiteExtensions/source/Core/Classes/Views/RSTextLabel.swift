//
//  RSTextLabel.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/15/18.
//

import UIKit

open class RSTextLabel: RSLabel {
    
    override open var defaultFont: UIFont {
        return RSFonts.computeFont(startingTextStyle: UIFontTextStyle.subheadline, defaultSize: 15.0, typeAdjustment: 17.0)
    }

}
