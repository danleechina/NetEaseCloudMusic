//
//  SongLyric.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/8/11.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import Foundation

class SongLyric: NSObject {
    
    var lyric: String? = ""
    var nickname = ""
    var klyric: String? = ""
    var tlyric: String? = ""
    
    lazy var lyricArray: Array<String> = {
        return self.getLyricWithTime().lyric
    }()
    
    lazy var tLyricArray: Array<String> = {
        return self.getTLyricWithTime().lyric
    }()
    
    lazy var kLyricArray: Array<String> = {
        return self.getKLyricWithTime().lyric
    }()
    
    lazy var lyricTimeArray: Array<Float64> = {
        return self.getNumValueFromFormatTimeStringArray(self.getLyricWithTime().time)
    }()
    
    lazy var kLyricTimeArray: Array<Float64> = {
        return self.getNumValueFromFormatTimeStringArray(self.getKLyricWithTime().time)
        
    }()
    
    lazy var tLyricTimeArray: Array<Float64> = {
        return self.getNumValueFromFormatTimeStringArray(self.getTLyricWithTime().time)
    }()
    
    
    class func getSongLyricFromRawData(data: String?) -> SongLyric? {
        let lyric = SongLyric()
        
        do {
            if data != nil {
                
                let dict = try NSJSONSerialization.JSONObjectWithData((data?.dataUsingEncoding(NSUTF8StringEncoding))!, options: []) as? [String:AnyObject]
                if ((dict!["uncollected"]?.boolValue) != nil)  {
                    return nil
                }
                //                lyric.nickname = dict!["lyricUser"]?["nickname"] as! String
                lyric.lyric = dict!["lrc"]?["lyric"] as? String
                lyric.klyric = dict!["klyric"]?["lyric"] as? String
                lyric.tlyric = dict!["tlyric"]?["lyric"] as? String
            } else {
                return nil
            }
        } catch let error as NSError {
            print(error)
        }
        
        
        return lyric
    }
    
    func getLyricWithTime() ->  (time: Array<String>, lyric:Array<String>){
        var retTime = Array<String>()
        var retLyric = Array<String>()
        if let str = self.lyric {
            (retTime, retLyric) = seperateFormatData(str)
        }
        return (retTime, retLyric)
    }
    
    func getTLyricWithTime() -> (time: Array<String>, lyric: Array<String>){
        var retTime = Array<String>()
        var retLyric = Array<String>()
        if let str = self.tlyric {
            (retTime, retLyric) = seperateFormatData(str)
        }
        return (retTime, retLyric)
    }
    
    func getKLyricWithTime() -> (time: Array<String>, lyric: Array<String>){
        var retTime = Array<String>()
        var retLyric = Array<String>()
        if let str = self.klyric {
            (retTime, retLyric) = seperateFormatData(str)
        }
        return (retTime, retLyric)
    }
    
    func seperateFormatData(str: String) -> (Array<String>, Array<String>) {
        var retTime = Array<String>()
        var retLyric = Array<String>()
        
        var startIndex = str.startIndex
        
        let resultStart = str.rangeOfString("[", options: .LiteralSearch, range: Range(startIndex ..< str.endIndex), locale: nil)
        if resultStart == nil {
            retLyric.append(str)
            retTime.append("00:00.000")
            return (retTime, retLyric)
        }
        while startIndex != str.endIndex {
            let resultStart = str.rangeOfString("[", options: .LiteralSearch, range: Range(startIndex ..< str.endIndex), locale: nil)
            let resultEnd = str.rangeOfString("]", options: .LiteralSearch, range: Range(startIndex ..< str.endIndex), locale: nil)
            let timeStr = str.substringWithRange(Range((resultStart?.startIndex.advancedBy(1))! ..< (resultEnd?.startIndex)!))
            
            let lyricResultStart = resultEnd?.startIndex.advancedBy(1)
            var lyricResultEnd = str.rangeOfString("[", options: .LiteralSearch, range: Range((resultEnd?.startIndex)! ..< str.endIndex), locale: nil)?.startIndex.advancedBy(-1)
            if lyricResultEnd == nil {
                lyricResultEnd = str.endIndex.advancedBy(-1)
            }
            var lyricStr = ""
            if lyricResultStart! < lyricResultEnd! {
                lyricStr = str.substringWithRange(Range(lyricResultStart! ..< lyricResultEnd!))
            }
            
            retTime.append(timeStr)
            retLyric.append(lyricStr)
            startIndex = (lyricResultEnd?.advancedBy(1))!
        }
        return (retTime, retLyric)
    }
    
    func getNumValueFromFormatTimeStringArray(strArray: Array<String>) -> Array<Float64> {
        var ret = Array<Float64>()
        for str in strArray {
            ret.append(SongLyric.getNumValueFromFormatTimeString(str))
        }
        return ret
    }
    
    class func getNumValueFromFormatTimeString(str: String) -> Float64 {
        let startIndex = str.startIndex
        let endIndex = str.endIndex.advancedBy(-1, limit: startIndex)
        let minStr = str.substringToIndex(startIndex.advancedBy(2, limit: endIndex))
        let secStr = str.substringFromIndex(startIndex.advancedBy(3, limit: endIndex))
        if let minValue = Float64(minStr), let secValue = Float64(secStr){
            return minValue * 60 + secValue
        }
        return 0
    }
    
    
    class func getFormatTimeStringFromNumValue(val: Float64) -> String {
        if val.isNaN {
            return "00:00"
        }
        let minVal = Int(val/60)
        let secVal = Int(val) - minVal * 60
        
        var minStr = "\(minVal)"
        var secStr = "\(secVal)"
        
        if minVal < 10 {
            minStr = "0\(minVal)"
        }
        if secVal < 10 {
            secStr = "0\(secVal)"
        }
        return minStr + ":" + secStr
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
