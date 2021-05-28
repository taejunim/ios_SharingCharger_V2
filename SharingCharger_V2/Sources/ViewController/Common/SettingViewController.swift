//
//  SettingViewController.swift
//  SharingCharger_V2
//  Description - 설정 ViewController
//  Created by 김재연 on 2021/04/14.
//
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var passwordChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.addGestureRecognizer(viewController: self, action: #selector(self.labelTapped(_:)), label: passwordChangeLabel)
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChange") as? PasswordChangeViewController else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //로그아웃 버튼 실행
    @IBAction func SignOutButton(_ sender: Any) {
        
        //자동 로그인 - UserDefaults 정보 삭제
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "password")

        var loginViewController: UIViewController!
        loginViewController = UIStoryboard(name:"Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
