//
//  LoginViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/6.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var qqButton: UIButton!
    @IBOutlet weak var weiboButton: UIButton!
    @IBOutlet weak var neteaseMailButton: UIButton!
    @IBOutlet weak var gradientLineView: UIView! {
        didSet {
//            gradientLineView.setGradientBackgroundColorInHorizontal(fromColor: UIColor.lightGray.withAlphaComponent(0.1), toColor: UIColor.lightGray.withAlphaComponent(0.5))
        }
    }
    @IBOutlet var gradientLine2View: UIView!{
        didSet {
//            gradientLine2View.setGradientBackgroundColorInHorizontal(fromColor: UIColor.lightGray.withAlphaComponent(0.1), toColor: UIColor.lightGray.withAlphaComponent(0.5))
        }
    }
    
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let segueID = segue.identifier else {
            return
        }
        let vc = segue.destination as! LoginDetailViewController
        vc.segueType = segueID
    }

}
