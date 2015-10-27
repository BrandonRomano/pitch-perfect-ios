//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Brandon Romano on 9/24/15.
//  Copyright © 2015 Digital Citadel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController : UIViewController {

    // ==================================================
    // MARK: Instance Variables
    // ==================================================
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // ==================================================
    // MARK: IBOutlets
    // ==================================================
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!

    // ==================================================
    // MARK: IBActions
    // ==================================================

    @IBAction func onRecordTouchDown(sender: AnyObject) {
        // Update UI
        recordingLabel.hidden = false
        stopRecordingButton.hidden = false
        
        // Record
        startRecording()
    }

    @IBAction func onStopRecordTouchDown(sender: UIButton) {
        stopRecording()
    }

    // ==================================================
    // MARK: UIViewController Overrides
    // ==================================================

    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.hidden = true
        recordingLabel.hidden = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController =
                segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    // ==================================================
    // MARK: Helpers
    // ==================================================

    func stopRecording(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func startRecording(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

}

// ==================================================
// MARK: - AVAudioRecorderDelegate
// ==================================================

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio();
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            stopRecordingButton.hidden = true
        }
    }

}