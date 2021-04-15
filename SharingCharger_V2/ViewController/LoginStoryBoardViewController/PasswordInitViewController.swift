//
//  PasswordInitViewController.swift
//  SharingCharger_V2
//
//  Created by guava on 2021/04/14.
//

class PasswordInitViewController: UIViewController, UITextFieldDelegate {

    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
    }
    
    
    @IBAction func passwordInitButton(_ sender: Any) {
       
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasswordInitComplete") as? PasswordInitCompleteViewController else { return }
       // viewController.userId = emailTextField.text!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
