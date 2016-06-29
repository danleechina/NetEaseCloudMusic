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
                    decodedString.
//                        if let data = data, response = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue:0)) {
//                            print(response)
//                        }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    
}
