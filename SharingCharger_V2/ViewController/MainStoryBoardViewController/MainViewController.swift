//
//  MainViewController.swift
//  SharingCharger_V2
//  Description - Main 화면 ViewController
//  Created by 조유영 on 2021/04/05.
//
import UIKit
import CoreLocation

class MainViewController: UIViewController, MTMapViewDelegate {

    @IBOutlet weak var mapView: UIView!
    var mTMapView: MTMapView?
    
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
    }
    
    //view가 나타난 후
    override func viewDidAppear(_ animated: Bool) {
        print("MainViewController - viewDidAppear")
        super.viewDidAppear(animated)
        
        print("롸???    \(locationManager.location?.coordinate)")
        if let defaultLatitude = locationManager.location?.coordinate.latitude , let defaultLongitude = locationManager.location?.coordinate.longitude{
                
            print("왜 안탐")
            let DEFAULT_POSITION = MTMapPointGeo(latitude: defaultLatitude, longitude: defaultLongitude)
            mTMapView?.setMapCenter(MTMapPoint(geoCoord: DEFAULT_POSITION), zoomLevel: 1, animated: true)
        }
    }
    
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
    
    func viewWillInitializeObjects(){
        
        requestGPSPermission()
        //지도 설정
        mTMapView = MTMapView(frame: mapView.bounds)
        if let mTMapView = mTMapView {
            
            mTMapView.delegate = self
            mTMapView.baseMapType = .standard
            mapView.addSubview(mTMapView)
        }
    }
    
    //위치 권한
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
}
