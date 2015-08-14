//
//  EffectPlayer.swift
//  Pitch Perfect
//
//  Created by Kevin Sjöberg on 13/08/15.
//  Copyright (c) 2015 Kevin Sjöberg. All rights reserved.
//

import Foundation
import AVFoundation

class EffectPlayer {
  var audioFile: AVAudioFile
  let audioEngine = AVAudioEngine()
  let audioPlayerNode = AVAudioPlayerNode()
  let audioUnitTimePitchNode = AVAudioUnitTimePitch()

  init(fromRecording recording: AudioRecording) {
    var error: NSError?

    // Convert our AudioRecording to an AVAudioFile and store it
    audioFile = AVAudioFile(forReading: recording.fileURL, error: &error)

    if error != nil {
      println("Failed to create audio file: \(error)")
    }

    // Attach and connect our nodes
    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(audioUnitTimePitchNode)

    audioEngine.connect(audioPlayerNode, to: audioUnitTimePitchNode, format: audioFile.processingFormat)
    audioEngine.connect(audioUnitTimePitchNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)

    // Start the audio engine
    audioEngine.startAndReturnError(&error)

    if error != nil {
      println("Failed to start audio engine: \(error)")
    }
  }


  func stop() {
    audioPlayerNode.stop()
  }

  func playAtRate(rate: Float) {
    audioUnitTimePitchNode.rate  = rate
    audioUnitTimePitchNode.pitch = 1.0
    playRecording()
  }

  func playAtPitch(pitch: Float) {
    audioUnitTimePitchNode.rate  = 1.0
    audioUnitTimePitchNode.pitch = pitch
    playRecording()
  }

  private func playRecording() {
      audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
      audioPlayerNode.play()
  }
}