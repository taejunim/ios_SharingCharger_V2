//
//  PasswordInitCompleteViewController.swift
//  SharingCharger_V2
//  Description - 비밀번호 변경2 화면 ViewController
//  Created by 김재연 on 2021/04/14.
//
import UIKit
import Alamofire

class PasswordInitCompleteViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var passwordInitCompleteButton: UIButton!
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")  //회색
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")  //파랑
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PasswordInitCompleteViewController - viewDidLoad")
        
        Common.setButton(button: passwordInitCompleteButton, able: true, color: ColorE0E0E0, radius: 7, action: #selector(passwordChangeButton), target : self)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
        
    }
    //비밀번호 변경 완료 버튼
    @objc func passwordChangeButton(sender: UIButton!) {
        print("비밀번호 변경 완료 버튼")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/user/v1/password"
        let parameters: Parameters = [
            "currentpasswword": "123456",
            "newpassword": "654321"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                
                print("obj : \(obj)")
                
                do {
                    
                    let JSONData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    
                    /*let instanceData = try JSONDecoder().decode(JoinObject.self, from: JSONData)*/
                    print("Result  ... \(JSONData)")
                    
                    //                    self.view.makeToast("회원가입이 완료되어 로그인 페이지으로 이동합니다.", duration: 2.0, position: .bottom) {didTap in
                    //                        if didTap {
                    //                            print("tap")
                    //                            self.navigationController?.popViewController(animated: true)
                    //                        } else {
                    //                            print("without tap")
                    //                            self.navigationController?.popViewController(animated: true)
                    //                        }
                    //                    }
                    
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
}
