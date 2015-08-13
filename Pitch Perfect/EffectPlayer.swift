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
  }


  func stop() {
    audioPlayerNode.stop()
    audioEngine.reset()
  }

  func playAtRate(rate: Float) {
    stop()

    audioUnitTimePitchNode.rate = rate

    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(audioUnitTimePitchNode)

    audioEngine.connect(audioPlayerNode, to: audioUnitTimePitchNode, format: audioFile.processingFormat)
    audioEngine.connect(audioUnitTimePitchNode, to: audioEngine.outputNode, format: audioFile.processingFormat)

    var error: NSError?
    audioEngine.startAndReturnError(&error)

    if error == nil {
      audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
      audioPlayerNode.play()
    } else {
      println("Failed to start audio engine: \(error)")
    }
  }

  func playAtPitch(pitch: Float) {
    stop()

    audioUnitTimePitchNode.pitch = pitch

    audioEngine.attachNode(audioPlayerNode)
    audioEngine.attachNode(audioUnitTimePitchNode)

    audioEngine.connect(audioPlayerNode, to: audioUnitTimePitchNode, format: audioFile.processingFormat)
    audioEngine.connect(audioUnitTimePitchNode, to: audioEngine.outputNode, format: audioFile.processingFormat)

    var error: NSError?
    audioEngine.startAndReturnError(&error)

    if error == nil {
      audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
      audioPlayerNode.play()
    } else {
      println("Failed to start audio engine: \(error)")
    }
  }
}