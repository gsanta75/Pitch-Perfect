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
    
    func playAudioWithRate(rate: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        playAndStopButton.selected = true
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFasrAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func playAndStopAudio(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            playAudioWithRate(1.0)
        }else{
            audioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
        }
    }

    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: {

            self.playAndStopButton.selected = !self.playAndStopButton.selected
        })
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        playAndStopButton.selected = true

    }

    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag {
            playAndStopButton.selected = !playAndStopButton.selected
        }
    }
    
    
    
    
}
