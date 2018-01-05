//
//  ViewController.swift
//  playManyVideos
//
//  Created by julien@macmini on 04/01/2018.
//  Copyright © 2018 OnOffOn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let audioClock = UnsafeMutablePointer<CMClock?>.allocate(capacity: 1)
    
    var movie = UIView()
    var movieLayer: AVPlayerLayer!
    var moviePlayer: AVPlayer!
    var numberOfVideos = 0
    var ornmentVideos =
        ["Chaconne_diminue_altoquinte3e.mp4",
         "Chaconne_diminue_altotaille2e.mp4",
         "Chaconne_diminue_bassedeviolon.mp4",
         "Chaconne_diminue_clavecin.mp4",
         "Chaconne_diminue_flute.mp4",
         "Chaconne_diminue_hautbois.mp4",
         "Chaconne_diminue_hautecontre.mp4",
         "Chaconne_diminue_theorbe.mp4",
         "Chaconne_diminue_violon.mp4"]
    
    var simpleVideos = [
        "Chaconne_simple_altoquinte3e.mp4",
        "Chaconne_simple_altotaille2e.mp4",
        "Chaconne_simple_bassedeviolon.mp4",
        "Chaconne_simple_clavecin.mp4",
        "Chaconne_simple_flute.mp4",
        "Chaconne_simple_hautbois.mp4",
        "Chaconne_simple_hautecontre.mp4",
        "Chaconne_simple_theorbe.mp4",
        "Chaconne_simple_violon.mp4"]

    var vidz: [InstrumentVideoMonitor] = []
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create an audio clock
        CMAudioClockCreate(kCFAllocatorDefault, audioClock)
        
        // Init video monitors
        let numberOfVideos = 20
        let rows = CGFloat(4)
        let cols = CGFloat(5)
        
        let cellWidth = view.frame.width / cols
        let cellHeight = (view.frame.height - 100) / rows
        
        for i in 0...(numberOfVideos-1){
            
            let x: CGFloat = CGFloat(i % Int(cols)) * cellWidth
            let rowIndex = Int(floor(Float(i) / Float(cols)))
            let y: CGFloat = CGFloat(rowIndex) * cellHeight
            
            let videoMonitor = InstrumentVideoMonitor(withClock: audioClock.pointee!,
                                                      andFrame: CGRect(x: x, y: y, width: cellWidth, height: cellHeight),
                                                      movieURL: Bundle.main.bundleURL.appendingPathComponent("videos", isDirectory: true).appendingPathComponent(simpleVideos[0]))
            vidz.append(videoMonitor)
            view.addSubview(videoMonitor.view)
        }
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- events
    
    @IBAction func playButtonTouched(_ sender: Any) {
        
        let startTime = CMTimeAdd(getHostTimeFromAudioClock(), CMTime(seconds: 1, preferredTimescale: getHostTimeFromAudioClock().timescale))
        
        for videoMonitor in vidz{
            videoMonitor.startMoviesAtHostTime(startTime: startTime)
        }
    }
    
    @IBAction func stopButtonTouched(_ sender: Any) {
        for videoMonitor in vidz{
            videoMonitor.stopMovies()
        }
    }
    
    @IBAction func gotoButtonTouched(_ sender: Any) {
        for videoMonitor in vidz{
            videoMonitor.transportMoviesTo(timeInSeconds: 20.0)
        }
    }
    
    //MARK:- helpers
    func getHostTimeFromAudioClock()->CMTime{
        return CMClockGetTime(audioClock.pointee!)
    }
}

