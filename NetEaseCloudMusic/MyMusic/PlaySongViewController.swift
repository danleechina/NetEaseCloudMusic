//
//  PlaySongViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class PlaySongViewController: UIViewController {
    //I made a mistake, I should let the type be UIButton not UIImageView, but I am lazy to change. So be it
    
    @IBOutlet weak var needleImageView: UIImageView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var themePicImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var loveImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var downloadImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var commentImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var settingImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var timePointLabel: UILabel!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var totalTimeLabel: UILabel!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var songProgressView: UIProgressView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var playModeImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var lastSongImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var playImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var nextImageView: UIImageView!{
        didSet {
            
        }
    }
    
    @IBOutlet weak var totalSettingImageView: UIImageView!{
        didSet {
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        var frame = view.frame
        frame.origin.y += 64
        frame.size.height -= 64
        view.frame = frame
    }

}
