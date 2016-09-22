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
    case `repeat` = 1
    case order = 2
    case cycle = 3
    case shuffle = 4
    
    mutating func next() {
        switch self {
        case .repeat:
            self = .order
        case .order:
            self = .cycle
        case .cycle:
            self = .shuffle
        case .shuffle:
            self = .repeat
        }
    }
}

protocol PlaySongServiceDelegate: class {
    func updateProgress(_ currentTime: Float64, durationTime: Float64)
    func didChangeSong()
}


class PlaySongService: NSObject {
    static let sharedInstance = PlaySongService()
    fileprivate override init() {}
    
    weak var delegate: PlaySongServiceDelegate?
    
    var playMode = PlayMode.order
    var playLists: CertainSongSheet?
    
    var currentPlaySong: Int = 0
    fileprivate var songPlayer: AVPlayer?
    fileprivate var out_context = 0
    fileprivate var playTimeObserver: AnyObject?
    fileprivate var netease = NetworkMusicApi.shareInstance
    
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
    func playCertainSong(_ index: Int) {
        if index == currentPlaySong {
            startPlay()
            return
        }
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
    func playStartPoint(_ percent: Float) {
        let timeScale = self.songPlayer?.currentItem?.asset.duration.timescale
        let targetTime = CMTimeMakeWithSeconds(Float64(percent) * CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!), timeScale!)
        songPlayer?.seek(to: targetTime)
    }
    
    func playStartTime(_ timeValue: Float64) {
        let timeScale = self.songPlayer?.currentItem?.asset.duration.timescale
        let targetTime = CMTimeMakeWithSeconds(timeValue, timeScale!)
        songPlayer?.seek(to: targetTime)
    }
    
    func startPlay() {
        if let player = songPlayer {
            player.play()
        } else {
            if let songInfo = getCertainSongInfo(0) {
                currentPlaySong = 0
                playIt(songInfo.mp3Url)
            }
        }
    }
    
    fileprivate func playIt(_ urlString: String) -> Void {
        print("songurl=" + urlString)
        let player = AVPlayer.init(url: URL.init(string: urlString)!)
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: &out_context)
        
        if let songplayer = songPlayer {
            songplayer.removeObserver(self, forKeyPath: "status")
            // songPlayer can only be assign here
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            if playTimeObserver != nil {
                songplayer.removeTimeObserver(playTimeObserver!)
                playTimeObserver = nil
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        songPlayer = player
        playTimeObserver = songPlayer?.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main, using: { [unowned self] (time) in
            let currentTime = CMTimeGetSeconds(time)
            let totalTime = CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!)
            self.delegate?.updateProgress(currentTime, durationTime: totalTime)
        }) as AnyObject?
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) -> Void {
        if context == &out_context {
            if let player = songPlayer {
                switch player.status {
                    case .unknown:
                        print("status=unknown")
                        break
                    case .readyToPlay:
                        print("status=ReadyToPlay")
//                        if player.currentItem?.duration.value <= 0 {
//                            print("can not play this song")
//                            playNext()
//                        }
                        player.play()
                        break
                    case .failed:
                        print("status=Failed")
                        break
                }

            }
        }
    }
    
    func playerItemDidReachEnd(_ notification: Notification) -> Void {
        print("playerItemDidReachEnd")
        if let playlists = playLists {
            if currentPlaySong == playlists.tracks.count && playMode == PlayMode.order {
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
                if playMode == .order {
                    return nil
                } else {
                    nextIndex = 0
                }
            }
            if playMode == .shuffle {
                nextIndex = Int(arc4random()) % (playlists.tracks.count)
            }
        } else {
            return nil
        }
        return getSongInfoWithIndex(nextIndex)
    }
    
    func getPrevSongInfo() -> SongInfo? {
        var prevIndex = 0
        if let playlists = playLists {
            prevIndex = currentPlaySong - 1
            if prevIndex < 0 {
                prevIndex = (playlists.tracks.count) - 1
            }
            if playMode == .shuffle {
                prevIndex = Int(arc4random()) % (playlists.tracks.count)
            }
        } else {
            return nil
        }
        return getSongInfoWithIndex(prevIndex)
    }
    
    func getCertainSongInfo(_ index: Int) -> SongInfo? {
        var certainIndex = index
        if let playlists = playLists {
            if certainIndex >= 0 && certainIndex < playlists.tracks.count {
                certainIndex = index
                playIt(playlists.tracks[currentPlaySong].mp3Url)
            }
        } else {
            return nil
        }
        return getSongInfoWithIndex(certainIndex)
    }
    
    func getCurrentSongInfo() -> SongInfo? {
        if playLists == nil {
            return nil
        }
        return getSongInfoWithIndex(currentPlaySong)
    }
    
    func getSongInfoWithIndex(_ index: Int) -> SongInfo? {
        let songInfo = SongInfo()
        songInfo.picUrl = (playLists?.tracks[index].album.picUrl)!
        songInfo.blurPicUrl = (playLists?.tracks[index].album.blurPicUrl)!
        songInfo.songname = (playLists?.tracks[index].name)!
        songInfo.singers = (playLists?.tracks[index].artists[0].name)!
        songInfo.mp3Url = (playLists?.tracks[index].mp3Url)!
        songInfo.indexInTheSongSheet = index
        songInfo.songID = (playLists?.tracks[index].id)!
        
        return songInfo
    }
    
    func getSongLyric(_ complete: @escaping (_ songLyric: SongLyric?) -> Void) {
        netease.songLyricWithSongID((getCurrentSongInfo()?.songID)!, complete: { (data, error) in
            complete(SongLyric.getSongLyricFromRawData(data))
        })
    }
    
}
