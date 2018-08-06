//
//  RSTitleLabel.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 1/15/18.
//

import UIKit
import ResearchKit

open class RSTitleLabel: RSLabel {

    override open var defaultFont: UIFont {
        return RSFonts.computeFont(startingTextStyle: UIFontTextStyle.headline, defaultSize: 17.0, typeAdjustment: 35.0, weight: UIFont.Weight.light)
    }

}
