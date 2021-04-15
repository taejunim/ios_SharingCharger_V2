//
//  LeftMenuViewController.swift
//  SharingCharger_V2
//  Description - 좌측 메뉴 ViewController
//  Created by 조유영 on 2021/04/14.
//

import Alamofire

class LeftMenuViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func settingButton(_ sender: Any) {
        print("LeftMenuViewController - Button tapped")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting") else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}
