//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Giuseppe Santaniello on 13/05/15.
//  Copyright (c) 2015 Giuseppe Santaniello. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playAndStopButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var recivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var playing = false { didSet { updateUI() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recivedAudio != nil {
            audioPlayer = AVAudioPlayer(contentsOfURL: recivedAudio.filePathUrl, error: nil)
            audioPlayer.enableRate = true
        }else{
            println("Files not found")
        }
        audioPlayer.delegate = self
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recivedAudio.filePathUrl, error: nil)
        
    }
    
    func updateUI(){
        if playing{
            playAndStopButton.selected = true
        }else{
            playAndStopButton.selected = false
        }
    }
    
    func resetAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithRate(rate: Float){
        resetAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        playing = true
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFasrAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playAndStopAudio(sender: UIButton) {
        if !playing {
            playAudioWithRate(1.0)
        }else{
            resetAllAudio()
            playing = false
        }
    }

    
    @IBAction func playChipmunkAudio(sender: UIButton) {
            playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){

        resetAllAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {
            
            // the data in the file has been scheduled but the player isn't actually done playing yet
            // calculate the approximate time remaining for the player to finish playing and then dispatch the notification to the main thread
            var playerTime = audioPlayerNode.playerTimeForNodeTime(audioPlayerNode.lastRenderTime)
            var delayInSecs = (Double(self.audioFile.length) - playerTime.sampleRate) / self.audioFile.processingFormat.sampleRate
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delayInSecs) * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.playing = false
            })
        })
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        playing = true

    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag {
            playing = false
        }
    }
    
    
    
    
}
