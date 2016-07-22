//
//  FindMusicViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 16/6/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit
import AVFoundation

class FindMusicViewController: BaseViewController {

    private var songPlayer = AVPlayer.init()
    private var out_context = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        playIt("http://m2.music.126.net/U2CxR3MGaqD-DHlsCYgksg==/3291937813618641.mp3")
    }
    
    /*
    func playIt(urlString: String) -> Void {
        let player = AVPlayer.init(URL: NSURL.init(string: urlString)!)
        songPlayer = player
        NSNotificationCenter .defaultCenter().addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: songPlayer.currentItem)
        songPlayer.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &out_context)
        songPlayer.play()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) -> Void {
        if context == &out_context {
            print("changed")
        }
    }

    func playerItemDidReachEnd(notification: NSNotification) -> Void {
        print("playerItemDidReachEnd")
    }
    
    func updateProgress() -> Void {
        print("updateProgress")
    }
 */
}
