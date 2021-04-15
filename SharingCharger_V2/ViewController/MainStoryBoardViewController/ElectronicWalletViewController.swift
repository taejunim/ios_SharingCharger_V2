//
//  ElectronicWalletViewController.swift
//  SharingCharger_V2
//
//  Created by 조유영 on 2021/04/15.
//

class ElectronicWalletViewController : UIViewController {
    
    @IBOutlet var walletView: UIView!
    @IBOutlet var plusView: UIView!
    
    @IBOutlet var pointBuyButton: UIButton!
    @IBOutlet var transferButton: UIButton!
    @IBOutlet var pointHistoryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = Common.addRightMenu(imageName: "menu_list", action: #selector(rightMenu), menuSize: CGSize(width:25, height:25), viewController: self)
        walletView.layer.cornerRadius = 40
        plusView.layer.cornerRadius = 40
        
        Common.setButton(button: pointBuyButton, able: true, color: nil, radius: 7, action: #selector(pointBuy), target: self)
        Common.setButton(button: transferButton, able: true, color: nil, radius: 7, action: #selector(transfer), target: self)
        Common.setButton(button: pointHistoryButton, able: true, color: nil, radius: 7, action: #selector(pointHistory), target: self)
    }
    
    @objc func rightMenu(){
        print("우측 메뉴 클릭")
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
