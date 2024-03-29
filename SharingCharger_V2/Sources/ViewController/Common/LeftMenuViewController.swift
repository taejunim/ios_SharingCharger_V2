//
//  LeftMenuViewController.swift
//  SharingCharger_V2
//  Description - 좌측 메뉴 ViewController
//  Created by 조유영 on 2021/04/14.
//

import UIKit
import Alamofire

class LeftMenuViewController: UIViewController {
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var reservationStateLabel: UILabel!
    
    @IBOutlet var chargerUseHistoryButton: UILabel!
    @IBOutlet var electronicWalletButton: UILabel!
    @IBOutlet var favoriteButton: UILabel!
    @IBOutlet var userCertificationButton: UILabel!
    @IBOutlet var callCenterButton: UILabel!
    
    let myUserDefaults = UserDefaults.standard
    
    var utils: Utils?
    var activityIndicator: UIActivityIndicatorView?
    
    let callCenterNumber = "064-725-6800"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.addGestureRecognizer(viewController: self, action: #selector(self.chargerUseHistoryButton(_:)), label: chargerUseHistoryButton)
        Common.addGestureRecognizer(viewController: self, action: #selector(self.electronicWalletButton(_:)), label: electronicWalletButton)
        Common.addGestureRecognizer(viewController: self, action: #selector(self.favoriteButton(_:)), label: favoriteButton)
        Common.addGestureRecognizer(viewController: self, action: #selector(self.userCertificationButton(_:)), label: userCertificationButton)
        Common.addGestureRecognizer(viewController: self, action: #selector(self.callCenterButton(_:)), label: callCenterButton)
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.hidesWhenStopped = true
    }
    
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
                    
                    self.pointLabel.text = self.setComma(value: point)
                    
                } else {
                    self.pointLabel.text = "-"
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("Unknown Error")
                    
                } else {
                    print("Unknown Error")
                }
                
                self.pointLabel.text = "-"
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
    
    @IBAction func settingButton(_ sender: Any) {
        print("LeftMenuViewController - Button tapped")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func chargerUseHistoryButton(_ sender: UITapGestureRecognizer) {
        print("충전기 사용 이력")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChargerUseHistory") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func electronicWalletButton(_ sender: UITapGestureRecognizer) {
        print("전자지갑")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ElectronicWallet") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func favoriteButton(_ sender: UITapGestureRecognizer) {
        print("즐겨찾기")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Favorite") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func userCertificationButton(_ sender: UITapGestureRecognizer) {
        print("회원 증명서")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserCertification") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func callCenterButton(_ sender: UITapGestureRecognizer) {
        
        let url = URL(string: "telprompt://\(callCenterNumber)")!
        let shared = UIApplication.shared
        
        if shared.canOpenURL(url) {
            shared.open(url, options: [:], completionHandler: nil)
        }else {
            print("전화 url을 열수 없습니다.")
        }
    }
}
