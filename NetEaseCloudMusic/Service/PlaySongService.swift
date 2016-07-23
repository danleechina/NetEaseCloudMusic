//
//  PlaySongService.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/23/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySongService: NSObject {
    static let sharedInstance = PlaySongService()
    private override init() {
        
    }
    
    var playMode = 0
    var playLists: CertainSongSheet?
    var currentPlaySong: Int = 0
    
    private var songPlayer: AVPlayer?
    private var out_context = 0

    
    // play next song
    func playNext() {
        currentPlaySong = (currentPlaySong + 1) % (playLists?.tracks.count)!
        playIt(playLists?.tracks[currentPlaySong]["mp3Url"] as! String)
    }
    
    // play prev song
    func playPrev() {
        currentPlaySong -= 1
        if currentPlaySong == -1 {
            currentPlaySong = (playLists?.tracks.count)! - 1
        }
        playIt(playLists?.tracks[currentPlaySong]["mp3Url"] as! String)
    }
    
    // play index'th song
    func playCertainSong(index: Int) {

    }
    
    // pause play
    func pausePlay() {
        songPlayer?.pause()
    }
    
    // play a song at a certain time point
    func playStartPoint() {
        
    }
    
    func play() {
        songPlayer?.play()
    }
    
    func playIt(urlString: String) -> Void {
        let player = AVPlayer.init(URL: NSURL.init(string: urlString)!)
        songPlayer = player
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: songPlayer!.currentItem)
        songPlayer!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &out_context)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) -> Void {
        if context == &out_context {
            if let player = songPlayer {
                switch player.status {
                    case .Unknown:
                        break
                    case .ReadyToPlay:
                        break
                    case .Failed:
                        break
                }

            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) -> Void {
        print("playerItemDidReachEnd")
    }
    
    func updateProgress() -> Void {
        print("updateProgress")
    }
}
