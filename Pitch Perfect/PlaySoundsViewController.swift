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
    var recordedAudio: RecordedAudio!
    var movieQuotePlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        session.setActive(true, error: nil)
        
        movieQuotePlayer = AVAudioPlayer(contentsOfURL: recordedAudio.fileURL, error: nil)
        movieQuotePlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.fileURL, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Playback

    func playMovieQuoteAt(#rate: Float) {
        stopAndRewindMovieQuote()
        movieQuotePlayer.rate = rate
        movieQuotePlayer.play()
    }
    
    func stopAndRewindMovieQuote() {
        movieQuotePlayer.stop()
        movieQuotePlayer.currentTime = 0.0
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playMovieQuoteAt(rate: 0.5)
    }
    
    @IBAction func playFast(sender: UIButton) {
        playMovieQuoteAt(rate: 2.0)
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        movieQuotePlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        let changePitchNode = AVAudioUnitTimePitch()
        changePitchNode.pitch = 1000
        audioEngine.attachNode(changePitchNode)
        
        audioEngine.connect(playerNode, to: changePitchNode, format: nil)
        audioEngine.connect(changePitchNode, to: audioEngine.outputNode, format: nil)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        playerNode.play()
    }
    
    @IBAction func stopPlayback(sender: UIButton) {
        stopAndRewindMovieQuote()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
