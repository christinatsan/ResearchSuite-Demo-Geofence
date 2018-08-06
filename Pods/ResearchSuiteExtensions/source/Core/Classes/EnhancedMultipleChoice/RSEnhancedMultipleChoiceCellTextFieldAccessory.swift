//
//  RSEnhancedMultipleChoiceCellTextFieldAccessory.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/26/18.
//

import UIKit
import ResearchKit

open class RSEnhancedMultipleChoiceCellTextFieldAccessory: UIStackView {

    open class func newView() -> RSEnhancedMultipleChoiceCellTextFieldAccessory? {
        let bundle = Bundle(for: RSEnhancedMultipleChoiceCellTextFieldAccessory.self)
        guard let views = bundle.loadNibNamed("RSEnhancedMultipleChoiceCellTextFieldAccessory", owner: nil, options: nil),
            let view = views.first as? RSEnhancedMultipleChoiceCellTextFieldAccessory else {
                return nil
        }
        
        
        
//        self.configureView(view: view, minimumValue: minimumValue, maximumValue: maximumValue)
        
        return view
    }
    
//    open class func configureView(view: RSSliderView, minimumValue: Int, maximumValue: Int, stepSize: Int = 1) {
//        
//        view.sliderView.numberOfSteps = (maximumValue - minimumValue) / stepSize
//        view.sliderView.maximumValue = Float(maximumValue)
//        view.sliderView.minimumValue = Float(minimumValue)
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(sliderTouched(_:)))
//        view.sliderView.addGestureRecognizer(tapGestureRecognizer)
//        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: view, action: #selector(sliderTouched(_:)))
//        view.sliderView.addGestureRecognizer(panGestureRecognizer)
//        
//        //        view.sliderView.isUserInteractionEnabled = false
//        
//        view.minimumValue = minimumValue
//        view.maximumValue = maximumValue
//    }

    @IBOutlet var textLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    
}
