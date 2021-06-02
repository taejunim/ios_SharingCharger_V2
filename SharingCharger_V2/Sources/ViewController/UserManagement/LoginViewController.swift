//
//  LoginViewController.swift
//  SharingCharger_V2
//  Description - Login 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import Toast_Swift
import CoreLocation

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var utils: Utils?
    var activityIndicator: UIActivityIndicatorView?
    
    let locationManager = CLLocationManager()
    let userApiService = UserApiService()   //User API Service
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Common.setKeyboard(view: self.view)
    
        locationManager.requestWhenInUseAuthorization() //위치 권한
        
        //로딩 뷰
        utils = Utils(superView: self.view)
        activityIndicator = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
        //UserDefaults에 ID, Password가 저장되어 있는 경우 자동 로그인 실행
        let id = UserDefaults.standard.string(forKey: "id")
        let password = UserDefaults.standard.string(forKey: "password")
        
        if id != nil && password != nil {
            autoLogin(id!, password!) //자동 로그인
        }
    }
    
    //로그인 버튼
    @IBAction func loginButton(_ sender: Any) {
        
        guard let id = Common.isEmptyTextField(textField: idTextField) else {
            Common.showToast(view: self.view, message: "아이디 또는 이메일을 입력하여 주십시오.")
            return
        }
        guard let password = Common.isEmptyTextField(textField: passwordTextField) else {
            Common.showToast(view: self.view, message: "비밀번호를 입력하여 주십시오.")
            return
        }

        login(id, password) //로그인 실행
    }
    
    //회원가입 버튼
    @IBAction func joinButton(_ sender: Any) {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Join") else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func passwordInitButton(_ sender: Any) {
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PasswordInit") else { return }
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.black  //백버튼 검은색으로
        self.navigationController?.navigationBar.backItem?.title = ""       //백버튼 텍스트 제거
        self.navigationController?.navigationBar.barTintColor = .white      //navigationBar 배경 흰색으로
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        super.viewWillDisappear(animated)
    }
    
    //navigation bar 숨기기
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    @IBAction func temp1(_ sender: Any) {
        let viewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Reservation")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func temp2(_ sender: Any) {
        let viewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "ChargerSearch")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func temp3(_ sender: Any) {
        let viewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Charge")
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //메인 화면 이동
    func MoveMainView() {
        var mainViewController: UIViewController!
        mainViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    //로그인 실행
    func login(_ id: String, _ password: String) {
        
        self.activityIndicator?.startAnimating()    //로딩 화면 실행 시작
        
        let parameters = ["email": id, "password": password]    //로그인 API 호출 Parameter
        
        //로그인 API 호출
        userApiService.login(parameters) { (status, message) in
            
            //API 호출 성공
            if status == "success" {
                //로그인 성공
                if message == "Login Successful" {
                    //자동 로그인 - UserDefaults에 ID, Password 저장
                    UserDefaults.standard.set(id, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")

                    self.MoveMainView()  //메인 화면 이동
                }
                //로그인 실패
                else {
                    /**Error message  정의 완료 후 추가 구현 필요 */
                    self.activityIndicator?.stopAnimating() //로딩 화면 실행 종료
                    Common.showToast(view: self.view, message: "회원가입이 실패하였습니다.")
                }
            }
            //API 호출 실패
            else {
                self.activityIndicator?.stopAnimating() //로딩 화면 실행 종료
                Common.showToast(view: self.view, message: "서버와의 통신이 실패하였습니다.")
            }
        }
    }
    
    //자동 로그인
    func autoLogin(_ id: String, _ password: String) {
        
        self.activityIndicator?.startAnimating()    //로딩 화면 실행 시작
        
        let parameters = ["email": id, "password": password]    //로그인 API 호출 Parameter
        
        //로그인 API 호출
        userApiService.login(parameters) { (status, message) in
            
            //API 호출 성공
            if status == "success" {
                //로그인 성공
                if message == "Login Successful" {
                    self.MoveMainView()  //메인 화면 이동
                }
                //로그인 실패
                else {
                    self.activityIndicator?.stopAnimating() //로딩 화면 실행 종료
                    Common.showToast(view: self.view, message: "로그인이 실패하였습니다.")
                    
                    //자동 로그인 - UserDefaults 정보 삭제
                    UserDefaults.standard.removeObject(forKey: "id")
                    UserDefaults.standard.removeObject(forKey: "password")
                    
                    //로그인 화면 이동
                    var viewController: UIViewController!
                    viewController = UIStoryboard(name:"Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                    let navigationController = UINavigationController(rootViewController: viewController)
                    
                    UIApplication.shared.windows.first?.rootViewController = navigationController
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            }
            //API 호출 실패
            else {
                self.activityIndicator?.stopAnimating() //로딩 화면 실행 종료
                Common.showToast(view: self.view, message: "서버와의 통신이 실패하였습니다.")
            }
        }
    }
}
