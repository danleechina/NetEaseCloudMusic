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
    private var netease = NetworkMusicApi.shareInstance
    
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
        songInfo.songID = "\(playLists?.tracks[nextIndex]["id"]!)"

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
        songInfo.songID = "\(playLists?.tracks[prevIndex]["id"]!)"

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
        songInfo.songID = "\(playLists?.tracks[certainIndex]["id"]!)"

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
        songInfo.songID = "\((playLists?.tracks[currentPlaySong]["id"])!)"
        return songInfo
    }
    
    
    func getSongLyric(complete: (songLyric: SongLyric?) -> Void) {
        netease.songLyricWithSongID((getCurrentSongInfo()?.songID)!, complete: { (data, error) in
            complete(songLyric: SongLyric.getSongLyricFromRawData(data))
        })
    }
    
}

class SongInfo: NSObject {
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    var mp3Url = ""
    var indexInTheSongSheet = 0
    var songID = ""
}


class SongLyric: NSObject {
    
    var lyric: String? = ""
    var nickname = ""
    var klyric: String? = ""
    var tlyric: String? = ""
    
    class func getSongLyricFromRawData(data: String?) -> SongLyric? {
        let lyric = SongLyric()
        
        do {
            if data != nil {
                
                let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
                lyric.nickname = dict!["lyricUser"]!["nickname"] as! String
                lyric.lyric = dict!["lrc"]!["lyric"] as? String
                lyric.klyric = dict!["klyric"]!["lyric"] as? String
                lyric.tlyric = dict!["tlyric"]!["lyric"] as? String
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
        }

        
        return lyric
    }
    
    
//    "sgc": false,
//    "sfy": false,
//    "qfy": false,
//    "lyricUser": {
//    "id": 33579068,
//    "status": 0,
//    "demand": 0,
//    "userid": 81989338,
//    "nickname": "Finale叶",
//    "uptime": 1440123040116
//    },
//    "lrc": {
//    "version": 3,
//    "lyric": "[by:Finale叶]\n[00:01.65]归程\n[00:03.63]\n[00:15.01]一条没有方向 走不出寂寞的巷\n[00:21.84]眸子上了 一层霜月光冰凉\n[00:29.35]一个小心翼翼 却无法愈合的伤\n[00:36.40]两人的影 映在黑暗里残破的墙\n[00:44.12]闪烁的灯光 黑白了梦想 欲望是汹涌海洋\n[00:51.39]暧昧的曲调 反复在吟唱\n[00:57.24]风吹动那扇窗 苔藓爬满旧时光\n[01:05.54]吱呀呀叫嚣 少年不敢触及的过往\n[01:12.00]雨淋过的站台 曾经只对你说过的情话\n[01:19.94]我一步步踏上寻找你的 未知的归程\n[01:29.25]一首没有情绪 听到流眼泪的歌\n[01:36.25]白色的衬衣 透明的痕迹\n[01:43.98]一段很长很长 到不会醒来的梦\n[01:51.26]梦里长巷 你头顶路灯昏暗的光\n[01:58.51]闪烁的灯光 黑白了梦想 欲望是汹涌海洋\n[02:05.90]暧昧的曲调 反复在吟唱\n[02:11.88]风吹动那扇窗 苔藓爬满旧时光\n[02:20.26]吱呀呀叫嚣 少年不敢触及的过往\n[02:26.45]雨淋过的站台 曾经只对你说过的情话\n[02:34.45]我一步步踏上寻找你的 未知的归程\n[02:42.05]另一个世界 会不会很冷 请记得告诉我\n[02:48.88]除了黑夜 有无白昼\n[03:01.01]风吹动那扇窗 苔藓爬满旧时光\n[03:09.35]吱呀呀叫嚣 少年不敢触及的过往\n[03:15.60]雨淋过的站台 曾经只对你说过的情话\n[03:23.53]我一步步踏上寻找你的 未知的归程\n[03:31.81]\n"
//    },
//    "klyric": {
//    "version": 0
//    },
//    "tlyric": {
//    "version": 0,
//    "lyric": null
//    },
//    "code": 200
}
