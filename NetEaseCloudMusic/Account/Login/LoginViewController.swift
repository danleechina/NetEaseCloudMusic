//
//  LoginViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/6.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var wechatButton: UIButton!
    @IBOutlet var qqButton: UIButton!
    @IBOutlet var weiboButton: UIButton!
    @IBOutlet var neteaseMailButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.navigationBar)
        self.navigationBar.titleString = "登录"
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.lineView.backgroundColor = UIColor.clear
        
        self.navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_topbar_icn_back")?.renderContent(toColor: UIColor.black), for: UIControlState())
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_topbar_icn_back_prs")?.renderContent(toColor: UIColor.black), for: .highlighted)
        
        viewInit()
    }
    
    func viewInit() {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
