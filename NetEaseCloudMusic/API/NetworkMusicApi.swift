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
    
    static let httpHeader = [ "Accept": "*/*",
                              "Accept-Encoding": "gzip,deflate,sdch",
                              "Connection": "keep-alive",
                              "Content-Type": "application/x-www-form-urlencoded",
                              "Host": "music.163.com",
                              "Referer": "http://music.163.com/search/",
                              "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36",
                              ]
    
    fileprivate override init() {
    }
    
    let modulus = "00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7" +
        "b725152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280" +
        "104e0312ecbda92557c93870114af6c9d05c4f7f0c3685b7a46bee255932" +
        "575cce10b424d813cfe4875d3e82047b97ddef52741d546b8e289dc6935b" +
    "3ece0462db0a22b8e7"
    let nonce = "0CoJUm6Qyw8W8jud"
    let pubKey = "010001"
    
    fileprivate lazy var secKey: String = {
        return self.createSecretKey(size: 16)
    }()
    
    fileprivate lazy var encSecKey: String = {
        return self.rsaEncrypt(text: self.secKey, pubKey: self.pubKey, modulus: self.modulus)
    }()
    
    func getCSRFToken() -> String? {
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            return nil
        }
        for cookie in cookies {
            if cookie.name == "__csrf" {
                return cookie.value
            }
        }
        return nil
    }
    
    func encrypted_request(text: String) -> String {
        let encText = aesEncrypt(text: aesEncrypt(text: text, secKey: nonce)!, secKey: secKey)
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
        request.timeoutInterval = 10
        request.httpMethod = method
        request.allHTTPHeaderFields = NetworkMusicApi.httpHeader
        
        if method == "POST" {
            let perStr = data?.plusSymbolToPercent()
            request.httpBody = perStr?.data(using: .utf8)
            dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
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
                }
            })
        } else if method == "GET" {
            dataTask = defaultSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
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
                }
            })
        }
        dataTask?.resume()
    }
    
    
    // 登录
    func login(_ userName: String, password: String, _ complete: @escaping CompletionBlock) {
        // http://music.163.com/api/login/
        self .logout()
        let urlStr = "https://music.163.com/weapi/login/"
        let passwordMD5 = password.md5()
        let data = ["username":userName, "password":passwordMD5, "rememberLogin":"true"]
        doHttpRequest("POST", url: urlStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    func logout() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        if DatabaseManager.shareInstance.logout() == true {
            NotificationCenter.default.post(name: .onUserLogout, object: nil)
        }
    }
    
    // 获取动态
    func getCurrentLoginUserActivity(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
        }
        let usrStr = "http://music.163.com/weapi/event/get/\(loginData.userID)"
        let data = ["username":loginData.loginName, "password":loginData.loginPwd, "rememberLogin":"true"]
        doHttpRequest("POST", url: usrStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    
    // 获取关注
    func getCurrentLoginUserFollows(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
         }
        let usrStr = "http://music.163.com/weapi/user/getfollows/\(loginData.userID)"
        let data: [String: Any] = ["offset":0, "limit":1000, "order": true]
        doHttpRequest("POST", url: usrStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    
    // 获取粉丝
    func getCurrentLoginUserFollowed(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
        }
        let usrStr = "http://music.163.com/weapi/user/getfolloweds/\(loginData.userID)"
        let data = ["username":loginData.loginName, "password":loginData.loginPwd, "rememberLogin":"true"]
        doHttpRequest("POST", url: usrStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    // 获取 level
    func getCurrentLoginUserLevel(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
        }
        let usrStr = "http://music.163.com/weapi/user/level/?csrf_token=\(self.getCSRFToken() ?? "")"
        let data = ["username":loginData.loginName, "password":loginData.loginPwd, "rememberLogin":"true"]
        doHttpRequest("POST", url: usrStr, data: encrypted_request(text: data.json), complete: complete)
    }
    
    //用户歌单
    func getUserPlayList(_ complete: @escaping CompletionBlock) {
        guard let loginData = DatabaseManager.shareInstance.getCurrentUserLoginData() else {
            complete(nil, nil)
            return
        }
        let usrStr = "http://music.163.com/api/user/playlist/?offset=0&limit=1000&uid=\(loginData.userID)"
        doHttpRequest("GET", url: usrStr, data: nil, complete: complete)
    }
    
    static let topList = [
        ["云音乐新歌榜", "/discover/toplist?id=3779629"],
        ["云音乐热歌榜", "/discover/toplist?id=3778678"],
        ["网易原创歌曲榜", "/discover/toplist?id=2884035"],
        ["云音乐飙升榜", "/discover/toplist?id=19723756"],
        ["云音乐电音榜", "/discover/toplist?id=10520166"],
        ["UK排行榜周榜", "/discover/toplist?id=180106"],
        ["美国Billboard周榜", "/discover/toplist?id=60198"],
        ["KTV嗨榜", "/discover/toplist?id=21845217"],
        ["iTunes榜", "/discover/toplist?id=11641012"],
        ["Hit FM Top榜", "/discover/toplist?id=120001"],
        ["日本Oricon周榜", "/discover/toplist?id=60131"],
        ["韩国Melon排行榜周榜", "/discover/toplist?id=3733003"],
        ["韩国Mnet排行榜周榜", "/discover/toplist?id=60255"],
        ["韩国Melon原声周榜", "/discover/toplist?id=46772709"],
        ["中国TOP排行榜(港台榜)", "/discover/toplist?id=112504"],
        ["中国TOP排行榜(内地榜)", "/discover/toplist?id=64016"],
        ["香港电台中文歌曲龙虎榜", "/discover/toplist?id=10169002"],
        ["华语金曲榜", "/discover/toplist?id=4395559"],
        ["中国嘻哈榜", "/discover/toplist?id=1899724"],
        ["法国 NRJ EuroHot 30周榜", "/discover/toplist?id=27135204"],
        ["台湾Hito排行榜", "/discover/toplist?id=112463"],
        ["Beatport全球电子舞曲榜", "/discover/toplist?id=3812895"]
    ]
    // 热门单曲 http://music.163.com/#/discover/toplist 50
    func top_songlist(index: Int = 0, offset: Int = 0, limit: Int = 100, complete: @escaping CompletionBlock) {
        let action = "http://music.163.com" + NetworkMusicApi.topList[index][1]
        doHttpRequest("GET", url: action, data: nil) { (dataString, error) in
            complete(dataString, error)
        }
    }
    
    // song ids --> song urls ( details )
    func songs_detail(songIDs: [String], complete: @escaping CompletionBlock) {
        let action = "http://music.163.com/api/song/detail?ids=[" + songIDs.joined(separator: ",") + "]"
        doHttpRequest("GET", url: action, data: nil) { (dataString, error) in
            complete(dataString, error)
        }
    }
    
    func rankSongList(index: Int, complete: @escaping CompletionBlock) {
        NetworkMusicApi.shareInstance.top_songlist(index: index) { (data, error) in
            if let err = error {
                complete(nil, err)
                return
            }
            if let ret = data?.findAll(for: "/song\\?id=(\\d+)") {
                let r = ret.unique
                NetworkMusicApi.shareInstance.songs_detail(songIDs: r) { (data, error) in
                    complete(data, error)
                }
            } else {
                let error = NSError.init(domain: "没有数据", code: 0, userInfo: nil)
                complete(nil, error)
            }
        }
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
    
    // 歌手单曲
    func artists() {
        //         action = 'http://music.163.com/api/artist/' + str(artist_id)
        
    }
    
    
    // album id --> song id set
    func album() {
        //         action = 'http://music.163.com/api/album/' + str(album_id)
        
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
