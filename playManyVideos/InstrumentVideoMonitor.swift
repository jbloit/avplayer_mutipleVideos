//
//  InstrumentVideoMonitor.swift
//  playManyVideos
//
//  Created by Julien Bloit on 1/5/18.
//  Copyright © 2018 OnOffOn. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/**
 Plays a video, given an audio clock master.
 */
class InstrumentVideoMonitor {
    
    public var view: UIView!
    private let audioClock: CMClock!
    public var frame: CGRect!
    private var moviePlayer: AVPlayer!
    private var altMoviePlayer: AVPlayer!
    private var movieURL: URL!
    private var altMovieURL: URL!
    private var movieLayer: AVPlayerLayer!

    
    /// alt movie version selection flag
    private var isAltSelected: Bool = false
    
    init(withClock: CMClock, andFrame: CGRect, movieURL: URL, altMovieURL: URL){
        
        self.audioClock = withClock
        self.frame = andFrame
        self.movieURL = movieURL
        self.altMovieURL = altMovieURL
        self.view = UIView(frame: self.frame)
        let asset = AVAsset(url: self.movieURL)
        let altAsset = AVAsset(url: self.altMovieURL)
        
        self.moviePlayer = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        self.altMoviePlayer = AVPlayer(playerItem: AVPlayerItem(asset: altAsset))
        
        self.movieLayer = AVPlayerLayer(player: self.moviePlayer)
        
        self.movieLayer.frame = view.bounds
        
        self.movieLayer.videoGravity = .resize
        self.view.layer.addSublayer(movieLayer)
        moviePlayer.masterClock = audioClock

        // necessary to allow syncing with external clock
        moviePlayer.automaticallyWaitsToMinimizeStalling = false
        altMoviePlayer.automaticallyWaitsToMinimizeStalling = false
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true

    }
    
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
        
        altMoviePlayer.rate = 0
        altMoviePlayer.preroll(atRate: 1.0, completionHandler: { (complete: Bool) in
            if complete {
                // using kCMTimeInvalid will indicates to play from the item’s current time
                self.altMoviePlayer.setRate(1.0, time: kCMTimeInvalid, atHostTime: startTime)
            } else {
                print("preload not done")
            }
        })
    }
    

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        toggleVersion()
    }
    
    func stopMovies(){
        let timeInit: CMTime = CMTimeMakeWithSeconds(0.0, getHostTimeFromAudioClock().timescale)
        moviePlayer.seek(to: timeInit)
        moviePlayer.rate = 0
        
        altMoviePlayer.seek(to: timeInit)
        altMoviePlayer.rate = 0
    }
    
    func transportMoviesTo(timeInSeconds: Float){
        let targetTransportTime = CMTimeMakeWithSeconds(Float64(timeInSeconds), getHostTimeFromAudioClock().timescale)
        moviePlayer.seek(to: targetTransportTime)
        altMoviePlayer.seek(to: targetTransportTime)
    }
    
    func getHostTimeFromAudioClock()->CMTime{
        return CMClockGetTime(audioClock)
    }
    
    /// Toggle the movie version being played
    func toggleVersion(){
        if isAltSelected {
            self.movieLayer.player = self.moviePlayer
            isAltSelected = false
        } else {
            self.movieLayer.player = self.altMoviePlayer
            isAltSelected = true
        }
    }
}
