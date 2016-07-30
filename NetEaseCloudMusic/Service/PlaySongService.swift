//
//  PlaySongService.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/23/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayMode: Int {
    case Repeat = 1
    case Order = 2
    case Cycle = 3
    case Shuffle = 4
    
    mutating func next() {
        switch self {
        case .Repeat:
            self = .Order
        case .Order:
            self = .Cycle
        case .Cycle:
            self = .Shuffle
        case .Shuffle:
            self = .Repeat
        }
    }
}

protocol PlaySongServiceDelegate: class {
    func updateProgress(currentTime: Float64, durationTime: Float64)
    func didChangeSong()
}


class PlaySongService: NSObject {
    static let sharedInstance = PlaySongService()
    private override init() {}
    
    weak var delegate: PlaySongServiceDelegate?
    
    var playMode = PlayMode.Order
    var playLists: CertainSongSheet? {
        didSet {
            currentPlaySong = 0
        }
    }
    
    var currentPlaySong: Int = 0
    
    private var songPlayer: AVPlayer?
    private var out_context = 0
    private var playTimeObserver: AnyObject?
    
    // play next song
    func playNext() {
        if let songInfo = getNextSongInfo() {
            currentPlaySong = songInfo.indexInTheSongSheet
            playIt(songInfo.mp3Url)
        }
    }
    
    // play prev song
    func playPrev() {
        if let songInfo = getPrevSongInfo() {
            currentPlaySong = songInfo.indexInTheSongSheet
            playIt(songInfo.mp3Url)
        }
    }
    
    // play index'th song
    func playCertainSong(index: Int) {
        if let songInfo = getCertainSongInfo(index) {
            currentPlaySong = index
            playIt(songInfo.mp3Url)
        }
    }
    
    // pause play
    func pausePlay() {
        songPlayer?.pause()
    }
    
    // play a song at a certain time point
    func playStartPoint(percent: Float) {
        let timeScale = self.songPlayer?.currentItem?.asset.duration.timescale
        let targetTime = CMTimeMakeWithSeconds(Float64(percent) * CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!), timeScale!)
        songPlayer?.seekToTime(targetTime)
    }
    
    func startPlay() {
        if let player = songPlayer {
            player.play()
        } else {
            playCertainSong(0)
        }
    }
    
    private func playIt(urlString: String) -> Void {
        let player = AVPlayer.init(URL: NSURL.init(string: urlString)!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &out_context)
        
        if let songplayer = songPlayer {
            songplayer.removeObserver(self, forKeyPath: "status")
            // songPlayer can only be assign here
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
            if playTimeObserver != nil {
                songplayer.removeTimeObserver(playTimeObserver!)
                playTimeObserver = nil
            }
        }
        songPlayer = player
        playTimeObserver = songPlayer?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue(), usingBlock: { [unowned self] (time) in
            let currentTime = CMTimeGetSeconds(time)
            let totalTime = CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!)
            self.delegate?.updateProgress(currentTime, durationTime: totalTime)
        })
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) -> Void {
        if context == &out_context {
            if let player = songPlayer {
                switch player.status {
                    case .Unknown:
                        break
                    case .ReadyToPlay:
                        player.play()
                        break
                    case .Failed:
                        break
                }

            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) -> Void {
        print("playerItemDidReachEnd")
        if let playlists = playLists {
            if currentPlaySong == playlists.tracks.count && playMode == PlayMode.Order {
                return
            }
            playNext()
            self.delegate?.didChangeSong()
        }
    }
    
    
    func getNextSongInfo() -> SongInfo? {
        var nextIndex = 0
        if let playlists = playLists {
            nextIndex = currentPlaySong + 1
            if nextIndex == playlists.tracks.count {
                if playMode == .Order {
                    return nil
                } else {
                    nextIndex = 0
                }
            }
            if playMode == .Shuffle {
                nextIndex = random() % (playlists.tracks.count)
            }
        } else {
            return nil
        }

        
        let songInfo = SongInfo()
        songInfo.picUrl = playLists?.tracks[nextIndex]["album"]!["picUrl"] as! String
        songInfo.blurPicUrl = playLists?.tracks[nextIndex]["album"]!["blurPicUrl"] as! String
        songInfo.songname = playLists?.tracks[nextIndex]["name"] as! String
        songInfo.singers = playLists?.tracks[nextIndex]["artists"]![0]["name"] as! String
        songInfo.mp3Url = playLists?.tracks[nextIndex]["mp3Url"] as! String
        songInfo.indexInTheSongSheet = nextIndex
        return songInfo
    }
    
    func getPrevSongInfo() -> SongInfo? {
        var prevIndex = 0
        if let playlists = playLists {
            prevIndex = currentPlaySong - 1
            if prevIndex < 0 {
                prevIndex = (playlists.tracks.count) - 1
            }
            if playMode == .Shuffle {
                prevIndex = random() % (playlists.tracks.count)
            }
        } else {
            return nil
        }
        
        let songInfo = SongInfo()
        songInfo.picUrl = playLists?.tracks[prevIndex]["album"]!["picUrl"] as! String
        songInfo.blurPicUrl = playLists?.tracks[prevIndex]["album"]!["blurPicUrl"] as! String
        songInfo.songname = playLists?.tracks[prevIndex]["name"] as! String
        songInfo.singers = playLists?.tracks[prevIndex]["artists"]![0]["name"] as! String
        songInfo.mp3Url = playLists?.tracks[prevIndex]["mp3Url"] as! String
        songInfo.indexInTheSongSheet = prevIndex
        return songInfo

    }
    
    func getCertainSongInfo(index: Int) -> SongInfo? {
        var certainIndex = index
        if let playlists = playLists {
            if certainIndex >= 0 && certainIndex < playlists.tracks.count {
                certainIndex = index
                playIt(playlists.tracks[currentPlaySong]["mp3Url"] as! String)
            }
        } else {
            return nil
        }
        
        let songInfo = SongInfo()
        songInfo.picUrl = playLists?.tracks[certainIndex]["album"]!["picUrl"] as! String
        songInfo.blurPicUrl = playLists?.tracks[certainIndex]["album"]!["blurPicUrl"] as! String
        songInfo.songname = playLists?.tracks[certainIndex]["name"] as! String
        songInfo.singers = playLists?.tracks[certainIndex]["artists"]![0]["name"] as! String
        songInfo.mp3Url = playLists?.tracks[certainIndex]["mp3Url"] as! String
        songInfo.indexInTheSongSheet = certainIndex
        return songInfo
    }
    
    func getCurrentSongInfo() -> SongInfo? {
        if playLists == nil {
            return nil
        }
        
        let songInfo = SongInfo()
        songInfo.picUrl = playLists?.tracks[currentPlaySong]["album"]!["picUrl"] as! String
        songInfo.blurPicUrl = playLists?.tracks[currentPlaySong]["album"]!["blurPicUrl"] as! String
        songInfo.songname = playLists?.tracks[currentPlaySong]["name"] as! String
        songInfo.singers = playLists?.tracks[currentPlaySong]["artists"]![0]["name"] as! String
        songInfo.mp3Url = playLists?.tracks[currentPlaySong]["mp3Url"] as! String
        songInfo.indexInTheSongSheet = currentPlaySong
        return songInfo
    }

    
}

class SongInfo: NSObject {
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    var mp3Url = ""
    var indexInTheSongSheet = 0
}
