//
//  ChargerUseHistoryViewController.swift
//  SharingCharger_V2
//  Description - 충전기 사용 이력 화면 ViewController
//  Created by 조유영 on 2021/04/14.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class ChargerUseHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchChargeConditionProtocol {
    func searchingChargeConditionDelegate(data: SearchChargeHistoryConditionObject) {
        NotificationCenter.default.post(name: .updateChargerSearchCondition, object: data, userInfo: nil)
    }
    
    
    @IBOutlet var tableView: UITableView!
    
    var utils                     : Utils?
    var activityIndicator         : UIActivityIndicatorView?
    
    
    /** 아직 이력 조회 API 파라미터가 정의되지 않아 임의로 1차년도떄와 같이  size, page, 시작날짜, 종료날짜, 정렬, 사용타입*/
    let size                                  = 10
    var page                                  = 1
    var startDate                             = ""
    var endDate                               = ""
    var sort                                  = "DESC"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)     //table view margin 제거
        
        navigationItem.rightBarButtonItem = Common.addRightMenu(imageName: "menu_list", action: #selector(rightMenu), menuSize: CGSize(width:25, height:25), viewController: self)
        
        //검색조건에서 돌아왔을때 탈 Event 등록
        NotificationCenter.default.addObserver(self, selector: #selector(updateChargeSearchCondition(_:)), name: .updateChargerSearchCondition, object: nil)
        
        //로딩 뷰
        utils             = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
    }
    
    @objc func rightMenu(){
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChargerUseHistorySearchCondition") else { return }
        
        let bottomSheet = Common.createHistorySearchCondition(rootViewController: self, sheetViewController : viewController)
        present(bottomSheet, animated: true, completion: nil)
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for:indexPath) as! ChargerUseHistoryCell
        return Cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 140
    }
    
    
    //검색조건에서 적용버튼으로 돌아왔을때 이벤트
    @objc func updateChargeSearchCondition(_ notification: Notification) {
        
        let data = notification.object as! SearchChargeHistoryConditionObject
        
        startDate       = data.startDate
        endDate         = data.endDate
        sort            = data.sort
        
        print("startDate     : \(startDate)")
        print("endDate       : \(endDate)")
        print("sort          : \(sort)")
        //이 하단부터 가져온 파라미터를 가지고 API를 새로 호출하면 됨
        //arr.removeAll()
        
        //page      = 1
        //getChargingHistoryData()
        
    }
    
}

extension Notification.Name {
    static let updateChargerSearchCondition = Notification.Name("updateChargeSearchCondition")
}
