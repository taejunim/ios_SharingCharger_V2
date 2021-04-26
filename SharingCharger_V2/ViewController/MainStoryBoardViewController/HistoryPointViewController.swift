//
//  HistoryPointViewController.swift
//  SharingCharger_V2
//  포인트 이력 화면 View Controller
//  Created by 김재연 on 2021/04/16.
//

import Alamofire

class HistoryPointViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var utils                     : Utils?
    var activityIndicator         : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)     //table view margin 제거
        
        //로딩 뷰
        utils             = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
        getPointUsageHistoryData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for:indexPath) as! HistoryPointTableCell
        return Cell
    }
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 100
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
    
    //포인트 이력
    func getPointUsageHistoryData(){
        
        //        var code: Int!  = 0
        
        //        let userId = myUserDefaults.integer(forKey: "userId")
        let url         = "http://api.msac.co.kr/ElectricWalletmanagement/PointUsageHistory"
        
        let parameters: Parameters = [
            "ID"      :"ID",
            "Value"      :"Value"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            //            code = response.response?.statusCode
            //
            //            switch response.result {
            //
            //                case .success(let obj):
            //
            //                do {
            //
            //                    let JSONData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            //                    let instanceData = try JSONDecoder().decode(PointHistoryObject.self, from: JSONData)
            //
            //                    if instanceData.numberOfElements != self.size {
            //
            //                        self.moreLoadFlag = false
            //
            //                    }else {
            //
            //                        self.moreLoadFlag = true
            //
            //                    }
            //
            //                    for content in instanceData.content {
            //
            //                        self.arr.append(content)
            //
            //                    }
            //                    self.tableView.dataSource = self
            //
            //                    DispatchQueue.main.async {
            //
            //                        self.tableView.delegate             = self
            //                        self.tableView.dataSource           = self
            //                        self.tableView.allowsSelection      = false
            //                        self.tableView.reloadData()
            //                    }
            //
            //                    if(self.moreLoadFlag == false){
            //
            //                        self.activityIndicator!.stopAnimating()
            //                        self.activityIndicator!.isHidden = true
            //                        return
            //                    }
            //
            //                    self.page += 1
            //                } catch {
            //                    print("error : \(error.localizedDescription)")
            //                    print("서버와 통신이 원활하지 않습니다. 고객센터로 문의주십시오. code : \(code!)")
            //                }
            //
            //            case .failure(let err):
            //
            //                print("error is \(String(describing: err))")
            //
            //                if code == 400 {
            //                    print("400 Error.")
            //                    self.view.makeToast("400 Error", duration: 2.0, position: .bottom)
            //
            //                } else {
            //                    print("Unknown Error")
            //                    self.view.makeToast("Error.", duration: 2.0, position: .bottom)
            //                }
            //            }
            
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.isHidden = true
        })
        
    }
    
    
}
