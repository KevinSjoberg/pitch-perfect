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
      let recording = sender as! AudioRecording
      let playSoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      playSoundsViewController.recording = recording
    }
  }

  // MARK: View actions

  @IBAction func recordAudio() {
    recordIndicator.text = "Recording..."
    microphoneButton.enabled = false
    stopRecordingButton.hidden = false

    // Set audio session category. This will silence playback audio while
    // recording.
    let session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryRecord, error: nil)
    session.setActive(true, error: nil)

    audioRecorder.record()
  }

  @IBAction func stopRecording() {
    recordIndicator.text = "Tap to record"
    microphoneButton.enabled = true
    stopRecordingButton.hidden = true
    audioRecorder.stop()

    // Restore previous session category and inactivate our audio session.
    let session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategorySoloAmbient, error: nil)
    session.setActive(false, error: nil)
  }

  // MARK: AVAudioRecorderDelegate

  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if (flag) {
      let recording = AudioRecording(fromRecorder: recorder)
      self.performSegueWithIdentifier("stopRecording", sender: recording)
    } else {
      println("Failed to record audio from user")
    }
  }
}