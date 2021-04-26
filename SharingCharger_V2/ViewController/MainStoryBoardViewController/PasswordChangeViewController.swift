//
//  PasswordChangeViewController.swift
//  SharingCharger_V2
//  Description - 비밀번호 변경2 ViewController
//  Created by 김재연 on 2021/04/15.
//
import UIKit
import Alamofire
import Toast_Swift

class PasswordChangeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var currentPasswordTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var passwordConfirmTextField: CustomTextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var passwordInitCompleteButton: UIButton!
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
    let myUserDefaults = UserDefaults.standard
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")  //회색
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")  //파랑
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PasswordChangeViewController - viewDidLoad")
        
        Common.setButton(button: passwordInitCompleteButton, able: true, color: ColorE0E0E0, radius: 7, action: #selector(passwordInitComplete), target : self)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
    }
    
    @objc func passwordInitComplete(sender: UIButton) {
        
        if myUserDefaults.string(forKey: "password")!.trimmingCharacters(in: .whitespacesAndNewlines) != currentPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.view.makeToast("현재 비밀번호가 일치하지 않습니다.", duration: 2.0, position: .bottom)
            return
        } else if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != passwordConfirmTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.view.makeToast("새 비밀번호가 일치하지 않습니다.", duration: 2.0, position: .bottom)
            return
        } else {
            changePassword()
        }
    }
    
    private func changePassword() {
        
        self.activityIndicator!.startAnimating()
        
        var code: Int! = 0
        
        //        let userId = myUserDefaults.string(forKey: "email")!
        let url = "https://api.msac.co.kr/user/v1/password"
        
        print("url : \(url)")
        
        let parameters: Parameters = [
            "password" : passwordTextField.text!
        ]
        
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"], interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                print(obj)
                
                self.activityIndicator!.stopAnimating()
                
                if code == 200 {
                    
                    self.view.makeToast("비밀번호가 변경되었습니다.", duration: 2.0, position: .bottom) {didTap in
                        
                        let loginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
                        let navigationController = UINavigationController(rootViewController: loginViewController)
                        
                        self.myUserDefaults.set(self.passwordTextField.text, forKey: "password")
                        
                        if didTap {
                            print("tap")
                            
                            UIApplication.shared.windows.first?.rootViewController = navigationController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        } else {
                            print("without tap")
                            
                            UIApplication.shared.windows.first?.rootViewController = navigationController
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
                } else {
                    print("요청 파라미터가 올바르지 않습니다.\n다시 확인하여 주십시오.")
                    self.view.makeToast("요청 파라미터가 올바르지 않습니다.\n다시 확인하여 주십시오.", duration: 2.0, position: .bottom)
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("요청 파라미터가 올바르지 않습니다.\n다시 확인하여 주십시오.")
                    self.view.makeToast("요청 파라미터가 올바르지 않습니다.\n다시 확인하여 주십시오.", duration: 2.0, position: .bottom)
                    
                } else {
                    print("서버와 통신이 원활하지 않습니다. 고객센터로 문의주십시오. code : \(code!)")
                    self.view.makeToast("서버와 통신이 원활하지 않습니다.\n고객센터로 문의주십시오.", duration: 2.0, position: .bottom)
                }
                
                self.activityIndicator!.stopAnimating()
            }
        })
    }
}

