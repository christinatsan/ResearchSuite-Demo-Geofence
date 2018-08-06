//
//  RSEnhancedInstructionStepViewController.swift
//  Pods
//
//  Created by James Kizer on 7/30/17.
//
//

import UIKit
import SwiftyGif

open class RSEnhancedInstructionStepViewController: RSQuestionViewController {

    var stackView: UIStackView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let step = self.step as? RSEnhancedInstructionStep else {
            return
        }
        
        var stackedViews: [UIView] = []

        if let image = step.image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackedViews.append(imageView)
        }
        else if let gifURL = step.gifURL {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.setGifFromURL(gifURL)
            stackedViews.append(imageView)
        }
        
        if let audioTitle = step.audioTitle,
            let path = Bundle.main.path(forResource: audioTitle, ofType: nil) {
            
            let url = URL(fileURLWithPath: path)
            if let audioPlayer = RSAudioPlayer(fileURL: url) {
                stackedViews.append(audioPlayer)
            }
            
        }
        
        let stackView = UIStackView(arrangedSubviews: stackedViews)
        stackView.distribution = .equalCentering
        stackView.frame = self.contentView.bounds
        self.stackView = stackView
        
        self.contentView.addSubview(stackView)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stackView.frame = self.contentView.bounds
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.stackView.frame = self.contentView.bounds
    }

}
