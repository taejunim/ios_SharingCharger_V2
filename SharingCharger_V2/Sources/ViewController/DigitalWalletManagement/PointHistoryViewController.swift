//
//  PointHistoryViewController.swift
//  SharingCharger_V2
//  Description - 포인트 이력 화면 View Controller
//  Created by 김재연 on 2021/04/16.
//

import Alamofire

class PointHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchPointHistoryProtocol {
    func searchPointConditionDelegate(data: SearchHistoryConditionObject) {
        NotificationCenter.default.post(name: .updatePointSearchCondition, object: data, userInfo: nil)
    }
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var utils                     : Utils?
    var activityIndicator         : UIActivityIndicatorView?
    
    
    /** 아직 이력 조회 API 파라미터가 정의되지 않아 임의로 1차년도떄와 같이  size, page, 시작날짜, 종료날짜, 정렬, 사용타입*/
    let size                                  = 10
    var page                                  = 1
    var startDate                             = ""
    var endDate                               = ""
    var sort                                  = "DESC"
    var pointUsedType                         = "ALL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)     //table view margin 제거
        
        navigationItem.rightBarButtonItem = Common.addRightMenu(imageName: "menu_list", action: #selector(rightMenu), menuSize: CGSize(width:25, height:25), viewController: self)
        
        //검색조건에서 돌아왔을때 탈 Event 등록
        NotificationCenter.default.addObserver(self, selector: #selector(updatePointSearchCondition(_:)), name: .updatePointSearchCondition, object: nil)
        
        //포인트 라벨 둥글게
        pointLabel.layer.cornerRadius = 7.0
        
        //로딩 뷰
        utils             = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
        getPointUsageHistoryData()
    }
    
    @objc func rightMenu(){
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchingPointHistoryCondition") else { return }
        
        let bottomSheet = Common.createHistorySearchCondition(rootViewController: self, sheetViewController : viewController)
        present(bottomSheet, animated: true, completion: nil)
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
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
    //검색조건에서 적용버튼으로 돌아왔을때 이벤트
    @objc func updatePointSearchCondition(_ notification: Notification) {
        
        let data = notification.object as! SearchHistoryConditionObject
        
        startDate       = data.startDate
        endDate         = data.endDate
        sort            = data.sort
        pointUsedType   = data.pointUsedType
        
        print("startDate     : \(startDate)")
        print("endDate       : \(endDate)")
        print("sort          : \(sort)")
        print("pointUsedType : \(pointUsedType)")
        //이 하단부터 가져온 파라미터를 가지고 API를 새로 호출하면 됨
        //arr.removeAll()
        
        //page      = 1
        //getChargingHistoryData()

    }
}
extension Notification.Name {
    static let updatePointSearchCondition = Notification.Name("updatePointSearchCondition")
}
