//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Sjöberg on 31/07/15.
//  Copyright (c) 2015 Kevin Sjöberg. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordIndicator: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set audio session category. This will silence playback audio while
        // recording.
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        session.setActive(true, error: nil)
        
        
        // Setup our recorder and use this class as the AVAudioRecorderDelegate
        let docsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let filePath = NSURL.fileURLWithPathComponents([docsPath, "voice.wav"])

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let recordedAudio = sender as! RecordedAudio
            let playSoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsViewController.recordedAudio = recordedAudio
        }
    }
    
    // MARK: View actions
    
    @IBAction func recordAudio() {
        recordIndicator.hidden = false
        microphoneButton.enabled = false
        stopRecordingButton.hidden = false
        audioRecorder.record()
    }
    
    @IBAction func stopRecording() {
        recordIndicator.hidden = true
        microphoneButton.enabled = true
        stopRecordingButton.hidden = true
        audioRecorder.stop()
        
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        let audio = RecordedAudio()
        
        if (flag) {
            audio.title = recorder.url.lastPathComponent
            audio.fileURL = recorder.url
        } else {
            println("Failed to record audio")
        }
        
        self.performSegueWithIdentifier("stopRecording", sender: audio)
    }
}