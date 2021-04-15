//
//  JoinViewController.swift
//  SharingCharger_V2
//  Description - 회원가입 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit

class JoinViewController: UIViewController {

    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var serviceUsePolicyButton: UIButton!
    @IBOutlet var privacyAgreeButton: UIButton!
    
    
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")  //회색
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")  //파랑
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JoinViewController - viewDidLoad")
        
        Common.setButton(button: confirmButton, able: true, color: ColorE0E0E0, radius: 7, action: #selector(joinButton), target : self)
        Common.setButton(button: serviceUsePolicyButton, able: true, color: nil, radius: 3.0, action: #selector(serviceUsePolicy), target: self)
        Common.setButton(button: privacyAgreeButton, able: true, color: nil, radius: 3.0, action: #selector(privacyAgree), target: self)
        Common.setButtonBorder(button: serviceUsePolicyButton, borderWidth: 1.0, borderColor: ColorE0E0E0)
        Common.setButtonBorder(button: privacyAgreeButton, borderWidth: 1.0, borderColor: ColorE0E0E0)
    }
    
    //회원가입 버튼
    @objc func joinButton(sender: UIButton!) {
        
        print("회원가입버튼")
    }
    //회원가입 버튼
    @objc func serviceUsePolicy(sender: UIButton!) {
        
        print("서비스이용약관버튼")
    }
    //개인정보 처리방침 동의여부 버튼
    @objc func privacyAgree(sender: UIButton!) {
        
        print("개인정보 처리방침 동의여부 버튼")
    }
    
}
