//
//  ReservationViewController.swift
//  SharingCharger_V2
//  Description - 예약진행 화면 ViewController
//  Created by 김재연 on 2021/04/23.
//


import UIKit
import Alamofire

class ReservationViewController: UIViewController {
    
    @IBOutlet var chargerNameLabel: UILabel!
    @IBOutlet var chargingPeriodLabel: UILabel!
    @IBOutlet var currentPointLabel: UILabel!
    @IBOutlet var expectedPointLabel: UILabel!
    @IBOutlet var resultPointLabel: UILabel!
    @IBOutlet var reservationButton: UIButton!
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
    let myUserDefaults = UserDefaults.standard
    
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")  //회색
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")  //파랑
    let ColorE74C3C: UIColor! = UIColor(named: "Color_E74C3C")  //빨강
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ReservationViewController - viewDidLoad")
        
        Common.setButton(button: reservationButton, able: true, color: ColorE0E0E0, radius: 7, action: #selector(reservationCompleteButton), target : self)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
    }
    //현재 잔여 포인트
    private func getPoint() {
        
        self.activityIndicator!.startAnimating()
        
        var code: Int! = 0
        
        
        let url = "http://api.msac.co.kr/ElectricWalletmanagement/PointLookup"
        
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                
                self.activityIndicator!.stopAnimating()
                
                if code == 200 {
                    
                    let point: Int = obj as! Int
                    
                    self.currentPointLabel.text = self.setComma(value: point)
                    
                } else {
                    self.currentPointLabel.text = "-"
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("Unknown Error")
                    
                } else {
                    print("Unknown Error")
                }
                
                self.currentPointLabel.text = "-"
                self.activityIndicator!.stopAnimating()
            }
        })
    }
    //차감 포인트
    private func expectedPoint() {
        
        self.activityIndicator!.startAnimating()
        
        var code: Int! = 0
        
        
        let url = "http://api.msac.co.kr/ElectricWalletmanagement/PointLookup"
        
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                
                self.activityIndicator!.stopAnimating()
                
                if code == 200 {
                    
                    let point: Int = obj as! Int
                    
                    self.expectedPointLabel.text = self.setComma(value: point)
                    
                } else {
                    self.expectedPointLabel.text = "-"
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("Unknown Error")
                    
                } else {
                    print("Unknown Error")
                }
                
                self.expectedPointLabel.text = "-"
                self.activityIndicator!.stopAnimating()
            }
        })
    }
    
    private func setComma(value: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))!
        
        return result
    }
    
    //예약 완료 버튼
    @objc func reservationCompleteButton(sender: UIButton!) {
        print("예약완료 버튼")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/shared-charger/v1/reservation"
        let parameters: Parameters = [
            "chargingStartDate": "",
            "chargingEndDate": "",
            "reservationType": "",
            "chargerId": "",
            "userId": "",
            "expectedPoints": ""
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
                    //                    print("중복된 이메일이 존재합니다. 다른 이메일로 가입하여 주십시오.")
                    //                    self.view.makeToast("중복된 이메일이 존재합니다.\n다른 이메일로 가입하여 주십시오.", duration: 2.0, position: .bottom)
                    
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
    
    func setObject(enable : Bool){
        
        if enable {
            
            currentPointLabel.backgroundColor = Color3498DB
            resultPointLabel.textColor = Color3498DB
            reservationButton.backgroundColor = Color3498DB
            reservationButton.isEnabled = true
            
        }else {
            
            currentPointLabel.backgroundColor = ColorE74C3C
            resultPointLabel.textColor = ColorE74C3C
            reservationButton.backgroundColor = ColorE0E0E0
            reservationButton.isEnabled = false
            
        }
        
    }
}
