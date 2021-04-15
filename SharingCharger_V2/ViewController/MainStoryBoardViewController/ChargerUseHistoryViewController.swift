//
//  ChargerUseHistoryViewController.swift
//  SharingCharger_V2
//  Description - 충전기 사용 이력 화면 ViewController
//  Created by 조유영 on 2021/04/14.
//

import UIKit

class ChargerUseHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = Common.addRightMenu(imageName: "menu_list", action: #selector(rightMenu), menuSize: CGSize(width:25, height:25), viewController: self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)     //table view margin 제거
        
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
    
    @objc func rightMenu(){
        print("오른쪽 메뉴")
    }
    
}
