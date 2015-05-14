//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Giuseppe Santaniello on 13/05/15.
//  Copyright (c) 2015 Giuseppe Santaniello. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var recivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if recivedAudio != nil {
            audioPlayer = AVAudioPlayer(contentsOfURL: recivedAudio.filePathUrl, error: nil)
            audioPlayer.enableRate = true
        }else{
            println("Files not found")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()

    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }
    
    @IBAction func playFasrAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    

}
