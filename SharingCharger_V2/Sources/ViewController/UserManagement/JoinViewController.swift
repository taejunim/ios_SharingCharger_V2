//
//  JoinViewController.swift
//  SharingCharger_V2
//  Description - 회원가입 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import Alamofire

class JoinViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var serviceUsePolicyButton: UIButton!
    @IBOutlet var privacyAgreeButton: UIButton!
    
    @IBOutlet var nameTextField: CustomTextField!
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var phoneNumberTextField: CustomTextField!
    @IBOutlet var autorizationCodeTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var passwordConfrimTextField: CustomTextField!
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
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
        Common.setKeyboard(view: self.view)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
        
    }
    
    //회원가입 버튼
    @objc func joinButton(sender: UIButton!) {
        print("회원가입버튼")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/user/v1/signup"
        let parameters: Parameters = [
            /*"username": nameTextField.text!,
            "name": phoneNumberTextField.text!,
            "password": emailTextField.text!,
            "phonenumber": passwordTextField.text!,
            "owner":"Gong Yoo"*/
            "username": "조",
            "name": "dbdud2407@test.com",
            "password": "12345",
            "phonenumber": "01012641234",
            "owner":"Gong Yoo"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                
                print("obj : \(obj)")
                
                do {
                    
                    let JSONData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    /*let instanceData = try JSONDecoder().decode(JoinObject.self, from: JSONData)*/
                    print("Result  ... \(JSONData)")
                    
                    self.view.makeToast("회원가입이 완료되어 로그인 페이지으로 이동합니다.", duration: 2.0, position: .bottom) {didTap in
                        if didTap {
                            print("tap")
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("without tap")
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                } catch {
                    print("error : \(error.localizedDescription)")
                    print("서버와 통신이 원활하지 않습니다. 고객센터로 문의주십시오. code : \(code!)")
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("중복된 이메일이 존재합니다. 다른 이메일로 가입하여 주십시오.")
                    self.view.makeToast("중복된 이메일이 존재합니다.\n다른 이메일로 가입하여 주십시오.", duration: 2.0, position: .bottom)

                } else {
                    if(code != nil){
                        print("서버와 통신이 원활하지 않습니다. 고객센터로 문의주십시오. code : \(code!)")
                        self.view.makeToast("서버와 통신이 원활하지 않습니다.\n고객센터로 문의주십시오.", duration: 2.0, position: .bottom)
                    } else {
                        self.view.makeToast("서버와 통신에 실패하였습니다.", duration: 2.0, position: .bottom)
                    }
                }
            }
            
            self.activityIndicator!.stopAnimating()
        })
            
    }
    //회원가입 버튼
    @objc func serviceUsePolicy(sender: UIButton!) {
        
        print("서비스이용약관버튼")
    }
    //개인정보 처리방침 동의여부 버튼
    @objc func privacyAgree(sender: UIButton!) {
        
        print("개인정보 처리방침 동의여부 버튼")
    }
    
    @objc func requestAuthentication(sender: UIButton!){
        print("JoinViewController - Button tapped")
        
        /*if phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.view.makeToast("전화번호를 입력하여주십시오", duration: 2.0, position: .bottom)
        }
        
        if !isValidPhone(phoneText: phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) {
            //키보드 올라온 상태이면 내리기
            if (activeTextField != nil) {
                activeTextField?.resignFirstResponder()
            }
            
            self.view.makeToast("전화번호 형식이 올바르지 않습니다.", duration: 2.0, position: .bottom)
        }*/
    }
}
