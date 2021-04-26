//
//  ChargeViewController.swift
//  SharingCharger_V2
//  Description - 충전 ViewController
//  Created by 김재연 on 2021/04/20.
//
import UIKit
import Alamofire

class ChargeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchCharger: UIButton!
    
    @IBOutlet var chargeStart: UIButton!
    @IBOutlet var chargeEnd: UIButton!
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")  //회색
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")  //파랑
    let ColorE74C3C: UIColor! = UIColor(named: "Color_E74C3C")  //빨강
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ChargeViewController - viewDidLoad")
        
        Common.setButton(button: chargeStart, able: true, color: ColorE0E0E0, radius: 7, action: #selector(chargeStartButton), target : self)
        Common.setButton(button: chargeEnd, able: true, color: ColorE0E0E0, radius: 7, action: #selector(chargeEndButton), target : self)
        Common.setButton(button: chargeEnd, able: true, color: ColorE0E0E0, radius: 7, action: #selector(chargeEndErrorButton), target : self)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)     //table view margin 제거
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for:indexPath) as! HistoryPointTableCell
        return Cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 60
    }
    
    //충전 시작 버튼
    @objc func chargeStartButton(sender: UIButton!) {
        print("충전시작 버튼")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/shared-charger/v1/charger-use-certification"
        let parameters: Parameters = [
            "authentication": "Charger ID",
            "starttime": "13:10:32",
            "reservationid": "23145",
            "userid": "Kim"
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
    
    //충전완료 버튼
    @objc func chargeEndButton(sender: UILabel!) {
        print("충전완료 버튼")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/shared-charger/v1/end-charging"
        let parameters: Parameters = [
            "chargerid": "Charger ID",
            "authenticationid": "Charger ID",
            "chargingtime": "123",
            "usage": "13"
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
    
    //비정상 충전 종료 버튼
    @objc func chargeEndErrorButton(sender: UIButton!) {
        print("비정상 충전 종료")
        var code: Int! = 0
        
        let url = "https://api.msac.co.kr/shared-charger/v1/charge-not-terminated"
        let parameters: Parameters = [
            "chargerid": "Charger ID",
            "authenticationid": "Charger ID",
            "chargingtime": "123",
            "usage": "13"
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
