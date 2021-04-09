//
//  LoginViewController.swift
//  SharingCharger_V2
//  Description - Login 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController - viewDidLoad")
        
        Common.setKeyboard(view: self.view)
    }
    
    //로그인 버튼
    @IBAction func loginButton(_ sender: Any) {
        print("loginButton tapped")

        guard let id = Common.isEmptyTextField(textField: idTextField) else {
            Common.showToast(view: self.view, message: "아이디 또는 이메일을 입력하여 주십시오.")
            return
        }
        guard let password = Common.isEmptyTextField(textField: passwordTextField) else {
            Common.showToast(view: self.view, message: "비밀번호를 입력하여 주십시오.")
            return
        }
        
        print("입력한 아이디 : \(id) 비밀번호 : \(password)")
        
        var mainViewController: UIViewController!
        mainViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    //회원가입 버튼
    @IBAction func joinButton(_ sender: Any) {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Join") else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black  //백버튼 검은색으로
        self.navigationController?.navigationBar.backItem?.title = ""       //백버튼 텍스트 제거
        self.navigationController?.navigationBar.barTintColor = .white      //navigationBar 배경 흰색으로
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        super.viewWillDisappear(animated)
    }
    
    //navigation bar 숨기기
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
}
