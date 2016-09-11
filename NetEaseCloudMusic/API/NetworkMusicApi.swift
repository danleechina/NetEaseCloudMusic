//
//  NetworkMusicApi.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/6/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation

class NetworkMusicApi: NSObject {
    static let shareInstance = NetworkMusicApi()
    private override init() {}
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask? = nil
    func doHttpRequest(method: String, url: String, data: Dictionary<String, String>?, complete: (data: String?, error: NSError?) -> Void) -> Void {
        //
        let request = NSMutableURLRequest.init()
        request.URL = NSURL.init(string: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4", forHTTPHeaderField: "Accept-Language")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("music.163.com", forHTTPHeaderField: "Host")
        request.setValue("http://music.163.com/search/", forHTTPHeaderField: "Referer")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 10
        request.HTTPMethod = method

        if method == "POST" {
//            let newdata = "username=349604757@qq.com&password=1d44443dc866fc6a79bda75a89807354&rememberLogin=true"
//            let nnd = newdata.dataUsingEncoding(NSUTF8StringEncoding)
//            let length = newdata.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//            request.HTTPBody = nnd
//            request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
            dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            })
        } else if method == "GET" {
            dataTask = defaultSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                if let err = error {
                    complete(data: nil, error: err)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let decodedString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        complete(data: decodedString as? String, error: nil)
                    } else {
                        complete(data: nil, error: nil)
                    }
                }
            })
        }
        dataTask?.resume()
    }
    
    
    // 登录
    func login(userName: String, password: String) -> Void {
        // http://music.163.com/api/login/
//        let md5Password = md5(string: password)
//        let urlStr = "http://music.163.com/api/login/"
//        let data = ["username":userName, "password":md5Password, "rememberLogin":"true"]
//        doHttpRequest("POST", url: urlStr, data: data)
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
    func top_playlists(complete: (data: String?, error: NSError?) -> Void) -> Void {
        // action = 'http://music.163.com/api/playlist/list?cat=' + category + '&order=' + order + '&offset=' + str(offset) + '&total=' + ('true' if offset else 'false') + '&limit=' + str(limit)
        let action = "http://music.163.com/api/playlist/list?cat=全部&order=hot&offset=0&total=false&limit=50"
        let escapedAddress = action.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        doHttpRequest("GET", url: escapedAddress!, data: nil, complete: complete)
    }
    
    
    // 歌单详情
    func playlist_detail(playListID: String, complete: (data: String?, error: NSError?) -> Void) -> Void {
        let action = "http://music.163.com/api/playlist/detail?id=" + playListID
        let escapedAddress = action.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        doHttpRequest("GET", url: escapedAddress!, data: nil, complete: complete)
        
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
    
    // 根据歌曲ID获取歌词
    func songLyricWithSongID(songId: Int, complete: (data: String?, error: NSError?) -> Void) -> Void {
        
        let action = "http://music.163.com/api/song/lyric?os=osx&id=\(songId)&lv=-1&kv=-1&tv=-1"
        doHttpRequest("GET", url: action, data: nil, complete: complete)

    }
    
    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
}
