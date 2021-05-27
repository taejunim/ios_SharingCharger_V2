//
//  ElectronicWalletViewController.swift
//  SharingCharger_V2
//
//  Created by 조유영 on 2021/04/15.
//
import Alamofire

class ElectronicWalletViewController : UIViewController {
    
    @IBOutlet var walletView: UIView!
    @IBOutlet var plusView: UIView!
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var pointBuyButton: UIButton!
    @IBOutlet var transferButton: UIButton!
    @IBOutlet var pointHistoryButton: UIButton!
    
    var utils                     : Utils?
    var activityIndicator         : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        walletView.layer.cornerRadius = 40
        plusView.layer.cornerRadius = 40
        
        Common.setButton(button: pointBuyButton, able: true, color: nil, radius: 7, action: #selector(pointBuy), target: self)
        Common.setButton(button: transferButton, able: true, color: nil, radius: 7, action: #selector(transfer), target: self)
        Common.setButton(button: pointHistoryButton, able: true, color: nil, radius: 7, action: #selector(pointHistory), target: self)
        
        //로딩 뷰
        utils             = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
    }
    
    //잔여 포인트 
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
    
    @objc func pointBuy(sender : UIButton!){
        print("포인트 구매")
    }
    @objc func transfer(sender : UIButton!){
        print("전송")
    }
    @objc func pointHistory(sender : UIButton!){
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PointUseHistory") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
