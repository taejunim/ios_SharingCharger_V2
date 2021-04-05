//
//  LoginViewController.swift
//  SharingCharger_V2
//  Description - Login 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController - viewDidLoad")
    }
    
    //로그인 버튼
    @IBAction func loginButton(_ sender: Any) {
        print("loginButton tapped")
        login()
    }
    
    //로그인
    private func login(){
        
        var mainViewController: UIViewController!
        mainViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
