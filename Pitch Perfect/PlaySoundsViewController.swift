//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Sjöberg on 31/07/15.
//  Copyright (c) 2015 Kevin Sjöberg. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  var recording: AudioRecording!
  var effectPlayer: EffectPlayer!

  override func viewDidLoad() {
    super.viewDidLoad()

    let session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
    session.setActive(true, error: nil)

    effectPlayer = EffectPlayer(fromRecording: recording)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: Playback

  @IBAction func playSlow(sender: UIButton) {
    effectPlayer.playAtRate(0.5)
  }

  @IBAction func playFast(sender: UIButton) {
    effectPlayer.playAtRate(2.0)
  }

  @IBAction func playChipmunk(sender: UIButton) {
    effectPlayer.playAtPitch(1000)
  }

  @IBAction func playDarthvader(sender: UIButton) {
    effectPlayer.playAtPitch(-1000)
  }

  @IBAction func stopPlayback(sender: UIButton) {
    effectPlayer.reset()
  }
}
