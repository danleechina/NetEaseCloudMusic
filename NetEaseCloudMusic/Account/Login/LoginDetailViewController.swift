//
//  LoginDetailViewController.swift
//  NetEaseCloudMusic
//
//  Created by Dan.Lee on 2016/12/7.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit

class LoginDetailViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var helpRegisterView: UIView!
    
    var segueType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.navigationBar)
        self.navigationBar.backgroundColor = UIColor.white
        self.navigationBar.leftButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_topbar_icn_back")?.renderContent(toColor: UIColor.black), for: UIControlState())
        self.navigationBar.leftButton.setImage(UIImage.init(named: "cm2_topbar_icn_back_prs")?.renderContent(toColor: UIColor.black), for: .highlighted)
        
        viewInit()
        
        accountTextField.tag = 0
        passwordTextField.tag = 1
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func viewInit() {
        guard let segueID = segueType else {
            return
        }
        
        accountTextField.leftViewMode = .always
        passwordTextField.leftViewMode = .always
        
        let accountLeftImageView = UIImageView.init(image: UIImage.init(named: "cm2_login_icn_mobile"))
        let passwordLeftImageView = UIImageView.init(image: UIImage.init(named: "cm2_login_icn_pw"))
        
        let accountLeftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        accountLeftView.addSubview(accountLeftImageView)
        accountLeftImageView.center = CGPoint(x: 22, y: 22)
        accountTextField.leftView = accountLeftView
        
        
        let passwordLeftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        passwordLeftView.addSubview(passwordLeftImageView)
        passwordLeftImageView.center = CGPoint(x: 22, y: 22)
        passwordTextField.leftView = passwordLeftView
        
        
        switch segueID {
        case "LoginWithPhone":
            self.navigationBar.titleString = "手机号登录"
            self.accountTextField.placeholder = "手机号"
            self.passwordTextField.placeholder = "密码"
            self.signButton.setTitle("登录", for: .normal)
            self.helpLabel.text = "重设密码"
            self.helpLabel.isHidden = false
            self.helpRegisterView.isHidden = true
            break
        case "LoginWithNetEaseMail":
            accountLeftImageView.image = UIImage.init(named: "cm2_login_icn_email")
            self.navigationBar.titleString = "网易邮箱账号登录"
            self.accountTextField.placeholder = "登录邮箱"
            self.passwordTextField.placeholder = "密码"
            self.signButton.setTitle("登录", for: .normal)
            self.helpLabel.text = "找回密码"
            self.helpLabel.isHidden = false
            self.helpRegisterView.isHidden = true
            
            self.signButton.addTarget(self, action: #selector(signInWithMail), for: .touchUpInside)
            break
        case "Register":
            self.navigationBar.titleString = "手机号注册"
            self.accountTextField.placeholder = "输入手机号"
            self.passwordTextField.placeholder = "设置登录密码，不少于6位"
            self.signButton.setTitle("下一步", for: .normal)
            self.helpLabel.isHidden = true
            self.lineView.isHidden = true
            self.helpRegisterView.isHidden = false
            
            let chinaCodeLabel = UILabel()
            chinaCodeLabel.text = "+86"
            chinaCodeLabel.textColor = UIColor.black
            chinaCodeLabel.font = UIFont.systemFont(ofSize: 14)
            chinaCodeLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
            accountLeftView.addSubview(chinaCodeLabel)
            accountLeftView.frame = CGRect(x: 0, y: 0, width: 75, height: 44)
            chinaCodeLabel.center = CGPoint(x: 55, y: 22)
            break
        default:
            break
        }
        
    }
    
    func signInWithMail() {
        let email = accountTextField.text?.trimSpace()
        let password = passwordTextField.text?.trimSpace()
        guard let emailStr = email, let passwordStr = password else { return }
        guard emailStr.isEmail() else { return }
        signButton.setTitle("登录中...", for: .normal)
        NetworkMusicApi.shareInstance.login(emailStr, password: passwordStr) { (data, error) in
            self.signButton.setTitle("登录", for: .normal)
            if let err = error {
                print(err)
            }
            if let userID = DatabaseManager.shareInstance.newUserLogin(data: data) {
                let data = ["loginName": emailStr,
                            "loginPwd": passwordStr.md5(),
                            "userID": userID,
                            ] as [String : Any]
                DatabaseManager.shareInstance.storeLoginData(data: data)
                NotificationCenter.default.post(name: .onNewUserLogin, object: nil)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
}
