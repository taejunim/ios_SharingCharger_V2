//
//  SettingViewController.swift
//  SharingCharger_V2
//
//  Created by guava on 2021/04/14.
//

class SettingViewController: UIViewController {
    
    @IBOutlet var passwordChangeView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLabelTap()
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
            print("labelTapped")
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChange") as? PasswordChangeViewController else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
        }

        func setupLabelTap() {

            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            self.passwordChangeView.isUserInteractionEnabled = true
            self.passwordChangeView.addGestureRecognizer(labelTap)

        }


}
