//
//  SettingViewController.swift
//  SharingCharger_V2
//  Description - 설정 ViewController
//  Created by 김재연 on 2021/04/14.
//
import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var passwordChangeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.addGestureRecognizer(viewController: self, action: #selector(self.labelTapped(_:)), label: passwordChangeLabel)
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChange") as? PasswordChangeViewController else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
