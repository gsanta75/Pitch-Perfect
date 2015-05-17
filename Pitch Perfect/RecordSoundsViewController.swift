//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Giuseppe Santaniello on 13/05/15.
//  Copyright (c) 2015 Giuseppe Santaniello. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func recordAudio(sender: UIButton) {
        sender.enabled = false
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
        
        // Setup sounds file name and path folder
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        //println(filePath)
        
        var recordSettings: [NSObject : AnyObject] = [AVFormatIDKey:kAudioFormatAppleIMA4, AVSampleRateKey:44100.0, AVNumberOfChannelsKey:2, AVLinearPCMBitDepthKey:16, AVEncoderBitRateKey:AVAudioQuality.Max.rawValue]

        // Shared Audio session singleton
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(.Speaker, error: nil)
        // Record Audio
        var error: NSError?
        audioRecorder = AVAudioRecorder(URL: filePath, settings: recordSettings, error: &error)
        audioRecorder.delegate = self
        if let e = error {
            println(e.localizedDescription)
        }else{
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }

    @IBAction func stopRecordAudio(sender: UIButton) {
        //recordingLabel.text = "Recording..."
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url , title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecordAudio", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordAudio" {
            if let recordedAudio = sender as? RecordedAudio{
                if let dvc = segue.destinationViewController as? PlaySoundsViewController{
                    dvc.recivedAudio = recordedAudio
                    println(recordedAudio.filePathUrl)
                }
            }
        }
    }
    
}










