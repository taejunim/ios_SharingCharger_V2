//
//  MainViewController.swift
//  SharingCharger_V2
//  Description - Main 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import CoreLocation
import SideMenu
import MaterialComponents.MaterialBottomSheet
import Alamofire

class MainViewController: UIViewController, MTMapViewDelegate, AddressProtocol {
    
    
    @IBOutlet weak var mapView: UIView!
    
    let notificationCenter = NotificationCenter.default
    
    var utils: Utils?                                           //로딩뷰
    var activityIndicator: UIActivityIndicatorView?             //로딩뷰
    
    var mTMapView: MTMapView?
    
    let addressView = ShadowButton(type: .system)
    var labelChange = true
    
    var selectedAddressObject: SelectedPositionObject? = nil
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var searchingConditionView = ShadowView()
    //var chargerView: BottomSheetView?
    var bottomButton = CustomButton(type: .system)
    
    var isCurrentLocationTrackingMode = false
    
    override func viewDidLoad() {
        print("MainViewController - viewDidLoad")
        super.viewDidLoad()
        viewWillInitializeObjects()
    }
    
    //충전기 목록 가져오기
    private func getChargerList() {
        var code: Int! = 0
        
        //        let chargerId = poiItem.tag
        let url = "https://api.msac.co.kr/shared-charger/v1"
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: Interceptor(indicator: activityIndicator!)).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
            
            switch response.result {
            
            case .success(let obj):
                print(obj)
            //                do {
            //
            //                    let JSONData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
            //                    let instanceData = try JSONDecoder().decode(ChargerObject.self, from: JSONData)
            //
            //                    self.selectedChargerObject = instanceData
            //
            //                } catch {
            //                    print("error : \(error.localizedDescription)")
            //                    print("서버와 통신이 원활하지 않습니다.\n문제가 지속될 시 고객센터로 문의주십시오. code : \(code!)")
            //                    self.view.makeToast("서버와 통신이 원활하지 않습니다.\n문제가 지속될 시 고객센터로 문의주십시오. code : \(code!)", duration: 2.0, position: .bottom)
            //                }
            
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("400 Error.")
                    self.view.makeToast("서버와 통신이 원활하지 않습니다.\n문제가 지속될 시 고객센터로 문의주십시오. code : \(code!)", duration: 2.0, position: .bottom)
                    
                } else {
                    print("Unknown Error")
                    self.view.makeToast("서버와 통신이 원활하지 않습니다.\n문제가 지속될 시 고객센터로 문의주십시오. code : 알 수 없는 오류", duration: 2.0, position: .bottom)
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        Common.showNavigationController(navigationController : self.navigationController , show : true)
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Common.showNavigationController(navigationController : self.navigationController , show : false)
        super.viewWillAppear(animated)
        
        //view가 나타나기 전에 여기서 메모리 (myUserDefaults)에 저장되있는 예약 정보가 있다면 예약 팝업
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
        
        //위치 권한
        requestGPSPermission()
        
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
        addBottomButton(buttonName: "bottomButton", width: nil, height: 40, top: nil, left: 0, right: 0, bottom: 0, target: self.view, targetViewController: self)  //하단 버튼
        addButton(buttonName: "currentLocation", width: 40, height: 40, top: 70, left: nil, right: -15, bottom: nil, target: mapView)    //현재 위치 버튼
        addSearchingConditionView(width: nil, height: 110, top: nil, left: 15, right: -15, bottom: 0, target: mapView)  //검색 조건 버튼
        
        //delegate 에서 observer (다른 화면에서 메인화면으로 돌아왔을때 이벤트(searchingAddress) 등록)
        notificationCenter.addObserver(self, selector: #selector(searchingAddress(_:)), name: .searchAddress, object: nil)
    }
    
    //사이드메뉴, 주소 찾기 버튼 추가
    private func addButton(buttonName: String?, width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject) {
        
        if buttonName == "address" {
            
            mapView?.addSubview(addressView)
            
            addressView.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
            
        } else {
            let button = ShadowButton(type: .system)
            
            if buttonName == "currentLocation" {
                button.isCircle = true
            } else {
                button.isCircle = false
            }
            mapView?.addSubview(button)
            
            button.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target)
        }
    }
    
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
    
    //사이드 메뉴 버튼
    @objc func menuButton(sender: UIButton!) {
        print("MainViewController - menuButton tapped")
        self.performSegue(withIdentifier: "segueToLeftMenu", sender: self)
    }
    
    //주소 찾기 버튼
    @objc func addressButton(sender: UIButton!) {
        print("MainViewController - addressButton tapped")
        self.performSegue(withIdentifier: "segueToAddress", sender: self)
    }
    //검색 조건 버튼
    @objc func searchingConditionButton(sender: UIView!) {
        print("MainViewController - searchingConditionButton tapped")
        
        //현재 예약 가져오는 api 나오면 분기처리
        /*let reservationId = myUserDefaults.integer(forKey: "reservationId")
         
         //예약이 있을 경우 예약 팝업
         if reservationId > 0 {
         
         presentReservationPopup()
         }
         */
        //예약이 없으면 검색 조건 팝업
        //else {
        
        let viewController: UIViewController!
        let bottomSheet: MDCBottomSheetController!
        
        viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChargerSearchCondition")
        bottomSheet = MDCBottomSheetController(contentViewController: viewController)
        bottomSheet.preferredContentSize = CGSize(width: mapView.frame.size.width, height: mapView.frame.size.height)
        
        let shapeGenerator = MDCCurvedRectShapeGenerator(cornerSize: CGSize(width: 15, height: 15))
        bottomSheet.setShapeGenerator(shapeGenerator, for: .preferred)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .extended)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .closed)
        
        present(bottomSheet, animated: true, completion: nil)
        //}
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
        
        if segue.identifier == "segueToAddress" {
            print("좌표 넘기기 예제")
            if let searchingAddressViewController = segue.destination as? AddressViewController {
             
             if let userLatitude = locationManager.location?.coordinate.latitude , let userLongitude = locationManager.location?.coordinate.longitude{
             
             searchingAddressViewController.userLatitude = userLatitude
             searchingAddressViewController.userLongitude = userLongitude
             }
             if let mapLatitude = mTMapView?.mapCenterPoint.mapPointGeo().latitude , let mapLongitude = mTMapView?.mapCenterPoint.mapPointGeo().longitude{
             
             searchingAddressViewController.mapLatitude = mapLatitude
             searchingAddressViewController.mapLongitude = mapLongitude
             
             }
             
             //현재 주소를 주소 검색창으로 넘김
             searchingAddressViewController.defaultAddress = (self.addressView.titleLabel?.text)!
             searchingAddressViewController.delegate       = self
             }
        }
    }
    
    func addressDelegate(data: SelectedPositionObject ) {
        notificationCenter.post(name: .searchAddress, object: data, userInfo: nil)
    }
    
    //지도 클릭했을 때
    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        
        print("singleTapOn ")
        
        //showSearchingConditionView()
        
        //selectedChargerObject = nil
    }
    
    //지도 드래그가 끝났을때
    func mapView(_ mapView: MTMapView!, dragEndedOn mapPoint: MTMapPoint!) {
        print("dragEndedOn")
    
        //선택된 충전기가 있으면 충전기 정보를 보여주는 식으로...
        /*if selectedChargerObject != nil {
           
            showSearchingConditionView()
            selectedChargerObject = nil
        }*/
        
    }
    
    //지도 움직임 끝났을때
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        print("finishedMapMoveAnimation \(mapCenterPoint.mapPointGeo())")
        
        changeAddressButtonText(latitude: mapCenterPoint.mapPointGeo().latitude, longitude: mapCenterPoint.mapPointGeo().longitude, placeName: nil)
        labelChange = true
        
        //여기서 새로 충전기 조회 api 를 호출
    }
    
    //지도 중심점 변경
    func moveMapView(mapPoint : MTMapPoint){
        
        mTMapView?.setMapCenter( mapPoint, zoomLevel: 1, animated: true)
    
    }
    
    //위치 권한 요청
    private func requestGPSPermission() {
            
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "위치 권한이 요구됨", message: "내 위치 확인을 위해 권한이 필요합니다.", preferredStyle: UIAlertController.Style.alert)

            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //현재 위치 버튼
    @objc func currentLocationTrackingModeButton(sender: UIView!) {
        print("현재위치 벼튼")
        if hasLocationPermission() {
            
            if isCurrentLocationTrackingMode {
                
                mTMapView?.showCurrentLocationMarker = false
                mTMapView?.currentLocationTrackingMode = .off
                isCurrentLocationTrackingMode = false
                
            } else {

                mTMapView?.showCurrentLocationMarker = true
                mTMapView?.currentLocationTrackingMode = .onWithoutHeading
                isCurrentLocationTrackingMode = true
            }
        } else {
            requestGPSPermission()
        }
    }
    
    //검색 조건 화면 -> 메인화면 돌아왔을때
    @objc func searchingAddress(_ notification: Notification) {

        selectedAddressObject = notification.object as? SelectedPositionObject
       
        if let latitude = selectedAddressObject?.latitude , let longitude = selectedAddressObject?.longitude {

            let selectedAddress = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
            moveMapView(mapPoint: selectedAddress!)
        }
        
        labelChange = false
        changeAddressButtonText(latitude: nil, longitude: nil, placeName: selectedAddressObject?.place_name)
        
    }
    func changeAddressButtonText(latitude : Double?, longitude : Double?, placeName : String?){
  
        if labelChange {
            if(latitude != nil && longitude != nil ){
            
                let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
                geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
                    if let addressInstance = placemarks?[0] {
                 
                        let address = addressInstance.name
                        self.addressView.setTitle(address, for: .normal)
                
                    }
                })
            }
        } else if placeName != nil {

            self.addressView.setTitle(placeName, for: .normal)
        }
        
    }
    
    //Side Menu Setting
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
extension Notification.Name {
    static let updateSearchingCondition = Notification.Name("updateSearchingCondition")
    static let lookFavorite = Notification.Name("lookFavorite")
    static let reservationPopup = Notification.Name("reservationPopup")
    static let startCharge = Notification.Name("startCharge")
    static let searchAddress = Notification.Name("searchAddress")
}
