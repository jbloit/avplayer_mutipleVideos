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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.displayCurrentTime), userInfo: nil, repeats: true)

    }
    
    override func viewDidLayoutSubviews() {
        movieLayer.frame = movie.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moviePlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func displayCurrentTime(){

        let audioClock = UnsafeMutablePointer<CMClock?>.allocate(capacity: 1)
        CMAudioClockCreate(kCFAllocatorDefault, audioClock)
        let hostTime = CMClockGetTime(audioClock.pointee!)

        print("host time (from audio clock) \(hostTime.seconds)")
    }


}

