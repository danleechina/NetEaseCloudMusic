//
//  NetworkMusicApi.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/6/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation

class NetworkMusicApi: NSObject {

    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask? = nil
    
    func defaultFunc() -> Void {
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let url = NSURL(string: "http://music.163.com/discover/toplist")
        let request = NSMutableURLRequest.init(URL: url!)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4", forHTTPHeaderField: "Accept-Language")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("music.163.com", forHTTPHeaderField: "Host")
        request.setValue("http://music.163.com/search/", forHTTPHeaderField: "Referer")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        
        dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, urlResponse, error) in
            if let err = error {
                print(err.localizedDescription)
            } else if let httpResponse = urlResponse as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let decodedString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print(decodedString!)
//                        if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) {
//                            print(response)
//                        }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    func doHttpRequest(method: String, url: String, data: Dictionary<String, String>) -> Void {
        //
    }
    
    
    // 登录
    func login(userName: String, password: String) -> Void {
        // http://music.163.com/api/login/
    }
    
    //用户歌单
    func user_playlist() -> Void {
        // http://music.163.com/api/search/get/web
    }
    
    // 搜索单曲(1)，歌手(100)，专辑(10)，歌单(1000)，用户(1002) *(type)*
    func search() -> Void {
        // http://music.163.com/api/search/get/web
    }
    
    
    // 新碟上架 http://music.163.com/#/discover/album/
    func new_albums() -> Void {
        // action = 'http://music.163.com/api/album/new?area=ALL&offset=' + str(offset) + '&total=true&limit=' + str(limit)
        
    }
    
    
    // 歌单（网友精选碟） hot||new http://music.163.com/#/discover/playlist/
    func top_playlists() -> Void {
        // action = 'http://music.163.com/api/playlist/list?cat=' + category + '&order=' + order + '&offset=' + str(offset) + '&total=' + ('true' if offset else 'false') + '&limit=' + str(limit)

    }
    
    
    // 歌单详情
    func playlist_detail() -> Void {
        //         action = 'http://music.163.com/api/playlist/detail?id=' + str(playlist_id)

    }
    
    // 热门歌手 http://music.163.com/#/discover/artist/
    func top_artists() -> Void {
        //         action = 'http://music.163.com/api/artist/top?offset=' + str(offset) + '&total=false&limit=' + str(limit)

    }
    
    // 热门单曲 http://music.163.com/#/discover/toplist 50
    func top_songlist() -> Void {
        //         action = 'http://music.163.com/discover/toplist'

    }
    
    // 歌手单曲
    func artists() -> Void {
        //         action = 'http://music.163.com/api/artist/' + str(artist_id)

    }
    
    
    // album id --> song id set
    func album() -> Void {
        //         action = 'http://music.163.com/api/album/' + str(album_id)

    }
    
    
    // song ids --> song urls ( details )
    func songs_detail() -> Void {
        //         action = 'http://music.163.com/api/song/detail?ids=[' + (',').join(tmpids) + ']'

    }
    
    
    // song id --> song url ( details )
    func song_detail() -> Void {
        //         action = "http://music.163.com/api/song/detail/?id=" + str(music_id) + "&ids=[" + str(music_id) + "]"
    }

    
    // 今日最热（0）, 本周最热（10），历史最热（20），最新节目（30）
    func djchannels() -> Void {
        //         action = 'http://music.163.com/discover/djchannel?type=' + str(stype) + '&offset=' + str(offset) + '&limit=' + str(limit)

    }

    
    // DJchannel ( id, channel_name ) ids --> song urls ( details )
    // 将 channels 整理为 songs 类型
    func channel_detail() -> Void {
        //             action = 'http://music.163.com/api/dj/program/detail?id=' + str(channelids[i])

    }
    
    
}
