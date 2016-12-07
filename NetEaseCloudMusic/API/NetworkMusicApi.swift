//
//  NetworkMusicApi.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/6/29.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation
import CryptoSwift

class NetworkMusicApi: NSObject {
    static let shareInstance = NetworkMusicApi()
    fileprivate override init() {}
    
    let modulus = "00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7" +
        "b725152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280" +
        "104e0312ecbda92557c93870114af6c9d05c4f7f0c3685b7a46bee255932" +
        "575cce10b424d813cfe4875d3e82047b97ddef52741d546b8e289dc6935b" +
    "3ece0462db0a22b8e7"
    let nonce = "0CoJUm6Qyw8W8jud"
    let pubKey = "010001"
    
    func encrypted_request(text: String) -> String {
        let secKey = createSecretKey(size: 16)
        let encText = aesEncrypt(text: aesEncrypt(text: text, secKey: nonce)!, secKey: secKey)
        let encSecKey = rsaEncrypt(text: secKey, pubKey: pubKey, modulus: modulus)
        return "params=\(encText!)&encSecKey=\(encSecKey)"
    }
    
    func aesEncrypt(text: String, secKey: String) -> String? {
        do {
            let aes = try! AES(key: Array(secKey.utf8), iv:Array("0102030405060708".utf8), blockMode: .CBC, padding: PKCS7())
            let ciphertext = try aes.encrypt(text.utf8.map({$0}))
            return String.init(data: Data.init(bytes: ciphertext).base64EncodedData(), encoding: .utf8)
        } catch {
            
        }
        return nil
    }
    
    func rsaEncrypt(text: String, pubKey: String, modulus: String) -> String {
        let revertText = String(text.characters.reversed())
        let diStr = hexlify(revertText.data(using: .utf8)!)
        let di = BigUInt(diStr, radix: 16)
        let exponent = BigUInt(pubKey, radix: 16)
        let modulus = BigUInt(modulus, radix: 16)
        let ret = di!.power(exponent!, modulus: modulus!)
        let res = String.init(ret, radix: 16, uppercase: false)
        return res.zfill(minimunLength: 256)
    }
    
    func createSecretKey(size: Int) -> String {
        let str = (Data.generateRandomBytes(length: 16)?.hexEncodedString())!
        let sstr = str.substring(to: str.index(str.startIndex, offsetBy: 16))
        return sstr
    }
    typealias CompletionBlock = (_ result: String?, _ error: NSError?) -> Void
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask? = nil
    func doHttpRequest(_ method: String, url: String, data: String?, complete: @escaping CompletionBlock) {
        //
        let request = NSMutableURLRequest.init()
        request.url = URL.init(string: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4", forHTTPHeaderField: "Accept-Language")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("music.163.com", forHTTPHeaderField: "Host")
        request.setValue("http://music.163.com/search/", forHTTPHeaderField: "Referer")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 10
        request.httpMethod = method
        
        if method == "POST" {
            let perStr = data?.plusSymbolToPercent()
            request.httpBody = perStr?.data(using: .utf8)
            dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let err = error {
                    complete(nil, err as NSError?)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        complete(decodedString as? String, nil)
                    } else {
                        complete(nil, nil)
                    }
                }
            })
        } else if method == "GET" {
            dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let err = error {
                    complete(nil, err as NSError?)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        let decodedString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        complete(decodedString as? String, nil)
                    } else {
                        complete(nil, nil)
                    }
                }
            })
        }
        dataTask?.resume()
    }
    
    
    // 登录
    func login(_ userName: String, password: String, _ complete: @escaping CompletionBlock) {
        // http://music.163.com/api/login/
        let urlStr = "https://music.163.com/weapi/login/"
        let passwordMD5 = password.md5()
        let data = ["username":userName, "password":passwordMD5, "rememberLogin":"true"]
        doHttpRequest("POST", url: urlStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    // 获取动态
    func getCurrentLoginUserActivity(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
        }
        let usrStr = "http://music.163.com/weapi/event/get/\(loginData.userID!)"
        let data = ["username":loginData.loginName, "password":loginData.loginPwd, "rememberLogin":"true"]
        doHttpRequest("POST", url: usrStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    //用户歌单
    func user_playlist() {
        // http://music.163.com/api/search/get/web
    }
    
    // 搜索单曲(1)，歌手(100)，专辑(10)，歌单(1000)，用户(1002) *(type)*
    func search() {
        // http://music.163.com/api/search/get/web
    }
    
    
    // 新碟上架 http://music.163.com/#/discover/album/
    func new_albums() {
        // action = 'http://music.163.com/api/album/new?area=ALL&offset=' + str(offset) + '&total=true&limit=' + str(limit)
        
    }
    
    
    // 歌单（网友精选碟） hot||new http://music.163.com/#/discover/playlist/
    func top_playlists(_ complete: @escaping CompletionBlock) {
        // action = 'http://music.163.com/api/playlist/list?cat=' + category + '&order=' + order + '&offset=' + str(offset) + '&total=' + ('true' if offset else 'false') + '&limit=' + str(limit)
        let action = "http://music.163.com/api/playlist/list?cat=全部&order=hot&offset=0&total=false&limit=50"
        let escapedAddress = action.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        doHttpRequest("GET", url: escapedAddress!, data: nil, complete: complete)
    }
    
    
    // 歌单详情
    func playlist_detail(_ playListID: String, complete: @escaping CompletionBlock) {
        let action = "http://music.163.com/api/playlist/detail?id=" + playListID
        let escapedAddress = action.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        doHttpRequest("GET", url: escapedAddress!, data: nil, complete: complete)
        
    }
    
    // 热门歌手 http://music.163.com/#/discover/artist/
    func top_artists() {
        //         action = 'http://music.163.com/api/artist/top?offset=' + str(offset) + '&total=false&limit=' + str(limit)
        
    }
    
    // 热门单曲 http://music.163.com/#/discover/toplist 50
    func top_songlist() {
        //         action = 'http://music.163.com/discover/toplist'
        
    }
    
    // 歌手单曲
    func artists() {
        //         action = 'http://music.163.com/api/artist/' + str(artist_id)
        
    }
    
    
    // album id --> song id set
    func album() {
        //         action = 'http://music.163.com/api/album/' + str(album_id)
        
    }
    
    
    // song ids --> song urls ( details )
    func songs_detail() {
        //         action = 'http://music.163.com/api/song/detail?ids=[' + (',').join(tmpids) + ']'
        
    }
    
    
    // song id --> song url ( details )
    func song_detail() {
        //         action = "http://music.163.com/api/song/detail/?id=" + str(music_id) + "&ids=[" + str(music_id) + "]"
    }
    
    
    // 今日最热（0）, 本周最热（10），历史最热（20），最新节目（30）
    func djchannels() {
        //         action = 'http://music.163.com/discover/djchannel?type=' + str(stype) + '&offset=' + str(offset) + '&limit=' + str(limit)
        
    }
    
    
    // DJchannel ( id, channel_name ) ids --> song urls ( details )
    // 将 channels 整理为 songs 类型
    func channel_detail() {
        //             action = 'http://music.163.com/api/dj/program/detail?id=' + str(channelids[i])
        
    }
    
    // 根据歌曲ID获取歌词
    func songLyricWithSongID(_ songId: Int, complete: @escaping CompletionBlock) {
        
        let action = "http://music.163.com/api/song/lyric?os=osx&id=\(songId)&lv=-1&kv=-1&tv=-1"
        doHttpRequest("GET", url: action, data: nil, complete: complete)
        
    }
}
