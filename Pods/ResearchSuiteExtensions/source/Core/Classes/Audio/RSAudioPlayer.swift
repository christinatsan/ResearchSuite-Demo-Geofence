//
//  RSAudioPlayer.swift
//  ResearchSuiteExtensions
//
//  Created by James Kizer on 4/4/18.
//

import UIKit
import AVFoundation

open class RSAudioPlayer: UIStackView, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var audioInterruptedObserver: NSObjectProtocol!
    var playPauseButton: RSLabelButton!
    var resetButton: RSLabelButton!
    
    var isReset: Bool {
        return self.audioPlayer.currentTime == 0.0
    }
    
    var isPlaying: Bool {
        return self.audioPlayer.isPlaying
    }

    private func setupAudioSession() throws {
        
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        self.audioInterruptedObserver = NotificationCenter.default.addObserver(forName: .AVAudioSessionInterruption, object: nil, queue: nil, using: { [weak self](notification) in
            
            self?.audioPlayer.pause()
            
        })
        
    }

    public convenience init?(fileURL: URL) {

        guard let audioPlayer = try? AVAudioPlayer(contentsOf: fileURL) else {
            return nil
        }
        
        self.init(arrangedSubviews: [])
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 16.0
        
        self.audioPlayer = audioPlayer
        self.audioPlayer.delegate = self
        
        if self.audioPlayer.prepareToPlay() == false {
            return nil
        }
        
        do {
            try self.setupAudioSession()
        }
        catch {
            return nil
        }
        
        self.playPauseButton = RSLabelButton(frame: CGRect())
        self.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        self.playPauseButton.configuredColor = self.tintColor
        self.addArrangedSubview(self.playPauseButton)
        
        self.resetButton = RSLabelButton(frame: CGRect())
        self.resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        self.resetButton.configuredColor = self.tintColor
        self.addArrangedSubview(self.resetButton)

        
        self.updateUI()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
    }
    
    private func reset() {
        self.audioPlayer.stop()
        self.audioPlayer.currentTime = 0.0
        self.audioPlayer.prepareToPlay()
        self.updateUI()
    }
    
    @objc func playPauseButtonTapped() {
        
        if self.isPlaying {
            self.audioPlayer.pause()
        }
        else {
            self.audioPlayer.play()
        }
        self.updateUI()
    }
    
    @objc func resetButtonTapped() {
        self.reset()
    }
    
    public func updateUI() {
        
        self.playPauseButton.setTitle(self.isPlaying ? "Pause Audio" : "Play Audio", for: .normal)
        self.resetButton.setTitle("Reset Audio", for: .normal)
        self.resetButton.isEnabled = !self.isReset
    
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            self.reset()
        }
        
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
//        debugPrint(player)
//        debugPrint(error)
        
    }
    
    

}
