//
//  MainViewController.swift
//  SharingCharger_V2
//  Description - Main 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import CoreLocation
import SideMenu

class MainViewController: UIViewController, MTMapViewDelegate {

    @IBOutlet weak var mapView: UIView!
    var mTMapView: MTMapView?
    
    let addressView = ShadowButton(type: .system)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        print("MainViewController - viewDidLoad")
        super.viewDidLoad()
        viewWillInitializeObjects()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //navigation bar 숨기기
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
        
        //위치 권한이 없으면 위치 권한 메시지 띄움
        if !hasLocationPermission() {
            print("권한없음")
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    //view가 나타난 후
    override func viewDidAppear(_ animated: Bool) {
        print("MainViewController - viewDidAppear")
        super.viewDidAppear(animated)
        
        if let defaultLatitude = locationManager.location?.coordinate.latitude , let defaultLongitude = locationManager.location?.coordinate.longitude{
            // 현재 위치 좌표를 받아서 맵뷰 가운데에 맞춰줌
            let DEFAULT_POSITION = MTMapPointGeo(latitude: defaultLatitude, longitude: defaultLongitude)
            mTMapView?.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 1, animated: true)
        }
    }

    private func viewWillInitializeObjects(){
        

        
        //지도 설정
        mTMapView = MTMapView(frame: mapView.bounds)
        if let mTMapView = mTMapView {
            mTMapView.delegate = self
            mTMapView.baseMapType = .standard
            mapView.addSubview(mTMapView)
        }
        //메인 화면 버튼 추가
        addButton(buttonName: "menu", width: 40, height: 40, top: 15, left: 15, right: nil, bottom: nil, target: mapView)   //사이드 메뉴
        addButton(buttonName: "address", width: nil, height: 40, top: 15, left: 70, right: -15, bottom: nil, target: mapView)   //주소 검색
    }
   
    //사이드메뉴, 주소 찾기 버튼 추가
    private func addButton(buttonName: String?, width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject) {
        
        if buttonName == "address" {
            
            mapView?.addSubview(addressView)
            
            addressView.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
            
        } else {
            let button = ShadowButton(type: .system)
            
            mapView?.addSubview(button)
            
            button.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
        }
    }
   /*
    //충전 버튼, 예약 버튼 추가
    private func addBottomButton(buttonName: String?, width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject, targetViewController: AnyObject) {
        
        self.view.addSubview(bottomButton)
        
        bottomButton.setAttributes(buttonName: "bottomButton", width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target, targetViewController: targetViewController)
        
        bottomButton.gone()
        
        self.view.sendSubviewToBack(bottomButton)
    }
    
    private func addSearchingConditionView(width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject) {
        
        mapView?.addSubview(searchingConditionView)
        
        searchingConditionView.setAttributes(width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
    }
    
    private func addCurrentLocationButton(buttonName: String?, width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject) {
        
        let view = ShadowCircleView()
        
        mapView?.addSubview(view)
        
        view.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
    }
    */
    
    //사이드 메뉴 버튼
    @objc func menuButton(sender: UIButton!) {
        print("MainViewController - menuButton tapped")
        
        self.performSegue(withIdentifier: "segueToLeftMenu", sender: self)
    }
    
    //주소 찾기 버튼
    @objc func addressButton(sender: UIButton!) {
        print("MainViewController - addressButton tapped")
        //self.performSegue(withIdentifier: "segueToAddress", sender: self)
        
    }
    
    //위치 권한 체크
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            hasPermission = false
        case .authorizedAlways, .authorizedWhenInUse:
            hasPermission = true
        default:
            print("GPS: Default")
        }
        
        return hasPermission
    }
    
    //Side Menu
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToLeftMenu" {
            if let sideMenuNavigationController = segue.destination as? SideMenuNavigationController {
                
                sideMenuNavigationController.settings = makeSettings()
            }
        }
        
        /*if segue.identifier == "segueToAddress" {
            if let searchingAddressViewController = segue.destination as? SearchingAddressViewController {
                
                if let userLatitude = locationManager.location?.coordinate.latitude , let userLongitude = locationManager.location?.coordinate.longitude{
                
                    searchingAddressViewController.userLatitude = userLatitude
                    searchingAddressViewController.userLongitude = userLongitude
                }
                if let mapLatitude = mTMapView?.mapCenterPoint.mapPointGeo().latitude , let mapLongitude = mTMapView?.mapCenterPoint.mapPointGeo().longitude{
                    
                    searchingAddressViewController.mapLatitude = mapLatitude
                    searchingAddressViewController.mapLongitude = mapLongitude
                    
                }

                searchingAddressViewController.defaultAddress = (self.addressView.titleLabel?.text)!
                searchingAddressViewController.delegate       = self
            }
        }*/
    }
    
    private func selectedPresentationStyle() -> SideMenuPresentationStyle {
        
        return .menuSlideIn
    }
    
    private func makeSettings() -> SideMenuSettings {
        
        let presentationStyle = selectedPresentationStyle()
        presentationStyle.backgroundColor = .black
        presentationStyle.presentingEndAlpha = 0.5
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = self.view.frame.width * 0.85
        
        return settings
    }
    
    
}
