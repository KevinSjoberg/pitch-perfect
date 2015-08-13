//
//  AudioRecording.swift
//  Pitch Perfect
//
//  Created by Kevin Sjöberg on 12/08/15.
//  Copyright (c) 2015 Kevin Sjöberg. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecording: NSObject {
  var title: String?
  var fileURL: NSURL

  init(fromRecorder recorder: AVAudioRecorder) {
    title   = recorder.url.lastPathComponent
    fileURL = recorder.url
  }
}