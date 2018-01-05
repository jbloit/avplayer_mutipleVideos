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
    
    
    //MARK:- LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CMAudioClockCreate(kCFAllocatorDefault, audioClock)
        
        numberOfVideos = simpleVideos.count
        
        movie.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        movie.backgroundColor = UIColor.cyan
        view.addSubview(movie)
        
        let movieURL = Bundle.main.bundleURL.appendingPathComponent("videos", isDirectory: true).appendingPathComponent(simpleVideos[0])
        let asset = AVAsset(url: movieURL)
        
        moviePlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        movieLayer = AVPlayerLayer(player: moviePlayer)
        movieLayer.videoGravity = .resize
        movie.layer.addSublayer(movieLayer)
        moviePlayer.masterClock = audioClock.pointee
        moviePlayer.automaticallyWaitsToMinimizeStalling = false

        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.displayCurrentTime), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        movieLayer.frame = movie.bounds
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
        startMoviesAtHostTime(startTime: startTime)
    }
    @IBAction func stopButtonTouched(_ sender: Any) {
        stopMovies()
    }
    @IBAction func gotoButtonTouched(_ sender: Any) {
        transportMoviesTo(timeInSeconds: 20.0)
    }
    
    //MARK:- helpers
    
    /**
     Play movie from the beginning, and sync it with a given host start time, ie the host time
     for which we want the audio to hit the speaker.
     */
    func startMoviesAtHostTime(startTime: CMTime){
        moviePlayer.rate = 0
        moviePlayer.preroll(atRate: 1.0, completionHandler: { (complete: Bool) in
            if complete {
                // using kCMTimeInvalid will indicates to play from the item’s current time
                self.moviePlayer.setRate(1.0, time: kCMTimeInvalid, atHostTime: startTime)
            } else {
                print("preload not done")
            }
        })
    }
    
    func stopMovies(){
        let timeInit: CMTime = CMTimeMakeWithSeconds(0.0, getHostTimeFromAudioClock().timescale)
        moviePlayer.seek(to: timeInit)
        moviePlayer.rate = 0
    }

    func transportMoviesTo(timeInSeconds: Float){
        let targetTransportTime = CMTimeMakeWithSeconds(Float64(timeInSeconds), getHostTimeFromAudioClock().timescale)
        moviePlayer.seek(to: targetTransportTime)
    }
    
    func getHostTimeFromAudioClock()->CMTime{
        return CMClockGetTime(audioClock.pointee!)
    }
    
    @objc func displayCurrentTime(){
        print("host time (from audio clock) \(getHostTimeFromAudioClock().seconds)")
    }
    
}

