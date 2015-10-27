//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Brandon Romano on 9/25/15.
//  Copyright © 2015 Digital Citadel. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // ==================================================
    // MARK: Instance Variables
    // ==================================================

    var audioPlayer:AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio!
    
    // ==================================================
    // MARK: IBOutlets
    // ==================================================

    // ==================================================
    // MARK: IBActions
    // ==================================================
    
    @IBAction func onPlaySlowButtonClick(sender: UIButton) {
        playWithRate(0.5)
    }

    @IBAction func onPlayFastButtonClick(sender: UIButton) {
        playWithRate(2.0)
    }

    @IBAction func onStopButtonClick(sender: UIButton) {
        if(audioPlayer != nil){
            audioPlayer.stop()
        }
    }
    
    @IBAction func onChipmunkButtonClick(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func onDarthVaderButtonClick(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // ==================================================
    // MARK: UIViewController Overrides
    // ==================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preparing the Audio Player
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            audioPlayer.enableRate = true
            
            audioEngine = AVAudioEngine()
            try audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            print("Something went wrong creating the AV player...")
        }
    }

    // ==================================================
    // MARK: Helpers
    // ==================================================

    func playWithRate(playRate: Float){
        if(audioPlayer != nil){
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            audioPlayer.rate = playRate
            audioPlayer.play()
        }
    }

    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
 
}
