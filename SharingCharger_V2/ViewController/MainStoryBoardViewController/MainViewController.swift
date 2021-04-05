//
//  MainViewController.swift
//  SharingCharger_V2
//  Description - Main 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //navigation bar 숨기기
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
}
