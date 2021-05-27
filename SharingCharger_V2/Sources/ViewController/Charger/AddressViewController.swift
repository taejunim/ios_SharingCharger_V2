//
//  AddressViewController.swift
//  SharingCharger_V2
//  Description - 주소검색 ViewController
//  Created by 조유영 on 2021/04/15.
//

import UIKit
import Alamofire

protocol AddressProtocol {
    //메인화면으로 넘겨줄 데이터 정의
    func addressDelegate(data: SelectedPositionObject)
}
class AddressViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var utils                           : Utils?
    var activityIndicator               : UIActivityIndicatorView?
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchLabelButton: UIButton!
    @IBOutlet var addressTextField: UITextField!
    
    @IBOutlet var myLocationButton: UIButton!
    @IBOutlet var mapLocationButton: UIButton!
    
    //주소 검색 API는 'KakaoAK {카카오앱키}' 형식이므로 별도로 정의를 해야함, 주소 검색은 카카오developer에서 rest API 키를 가져와야한다.
    let kakaoApiKey = "KakaoAK 1dd0f407375bcc6f33fa0f913541e0b1"
    
    //메인에서 주소검색 화면으로 올때, 사용자의 좌표와 지도의 좌표를 가져오는데, 선택된 조건에 따라서 그 값을 searchLatitude , searchLongitude에 넣어준다
    var searchLatitude                  : Double?
    var searchLongitude                 : Double?
    
    //메인화면에서 넘겨받는 주소, 지도중심 좌표, 사용자 좌표
    var defaultAddress: String = ""
    var mapLatitude: Double?
    var mapLongitude: Double?
    var userLatitude: Double?
    var userLongitude: Double?
    
    //메인화면으로 넘어갈 데이터 정의를 클래스 내부에 정의
    var delegate: AddressProtocol?
    
    //메인화면으로 넘겨줄 Object
    var selectedPosition: SelectedPositionObject = SelectedPositionObject()
    
    //페이징 처리를 위한 변수
    var page = 1
    let size = 10
    var moreLoadFlag = false
    
    //API로 받아온 List를 테이블 뷰에 담기 위한 배열
    var arr:[KakaoAddressObject.Place] = []
    
    let ColorE0E0E0: UIColor! = UIColor(named: "Color_E0E0E0")
    let Color3498DB: UIColor! = UIColor(named: "Color_3498DB")
    let ColorBlack: UIColor! = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //로딩 뷰
        utils                            = Utils(superView: self.view)
        activityIndicator                = utils!.activityIndicator
        self.view.addSubview(activityIndicator!)
        
        addressTextField.delegate        = self
        
        self.tableView.delegate          = self
        self.tableView.dataSource        = self
        self.tableView.allowsSelection   = false
        
        //table view margin 제거
        self.tableView.separatorInset    = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        Common.setButton(button: searchLabelButton, able: false, color: nil, radius: 7, action: nil, target: nil)
        Common.addTopButton(buttonName: "close", width: 40, height: 40, top: 15, left: nil, right: -10, bottom: nil, target: self.view, targetViewController: self)
        
        myLocationButton.addTarget(self, action: #selector(setConditionButton(_:)), for: .touchUpInside)
        mapLocationButton.addTarget(self, action: #selector(setConditionButton(_:)), for: .touchUpInside)
        
        //메인화면에서 받아온 값을 textfield에 넣는다
        addressTextField.text = defaultAddress
        
        setConditionButton(myLocationButton)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //Cell을 Customizing 하는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.arr[indexPath.section]
        let Cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for:indexPath) as! AddressTableCell
        
        Cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tableViewClick)))
        if(row.place_name != nil){
            
            Cell.placeName?.text = row.place_name
            
        } else{
            
            Cell.placeName?.text = " "
            
        }
        
        if(row.category_name != nil){
           // Cell.placeGroupName?.text = checkCategory(categoryGroupCode : String(row.category_group_code!))
            Cell.placeGroupName?.text = row.category_group_name
            
        } else{
            
            Cell.placeGroupName?.text = " "
            
        }
        
        if(row.address_name != nil){
            Cell.address?.text = row.address_name
            
        } else{
            
            Cell.address?.text = " "
        }
        
        if(row.phone != nil){
            
            Cell.phoneNumber?.text = row.phone
            
        } else{
            
            Cell.phoneNumber?.text = " "
        }
        
        if(indexPath[0] == arr.count-1 && moreLoadFlag){
            getAddressList()
        }
        
        return Cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }

    
    func tableView(_ tableView:UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    //테이블 뷰 눌렀을때 등록할 이벤트
    @objc func tableViewClick(sender : UITapGestureRecognizer){
        
        //여기서 값을 넘겨줄 것이기 때문에 넘겨줄 값들을 아래와 같이 담는다
        let tapLocation = sender.location(in: tableView)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        if let selectedIndex = indexPath?[0] {
            
            if let x =  arr[selectedIndex].x , let y = arr[selectedIndex].y , let placeName = arr[selectedIndex].place_name{
                selectedPosition.longitude = Double(x)
                selectedPosition.latitude = Double(y)
                selectedPosition.place_name = placeName
                delegate?.addressDelegate(data : selectedPosition)
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
    
    //엔터 눌렀을때 event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //엔터 누르면 키보드 내리고 kakao api 호출
        textField.resignFirstResponder()
        //여기서 search 전 파라미터 , table view 초기화 등 하기
        arr.removeAll()
        page = 1
        getAddressList()
        return true
    }
    
    func getAddressList(){
        
        var code: Int!  = 0
        let headers: HTTPHeaders = [

            "Authorization": kakaoApiKey
                ]
        
        let query = addressTextField.text!
        
        if(query == ""){
            
            self.view.makeToast("검색 조건을 입력하여 주십시오.")
            return
        }
        
        let parameters: Parameters = [
                    "query" : query,
                    "page"  : page,
                    "size"  : size,
                    "sort"  : "distance",
                    "x"     : searchLongitude!,
                    "y"     : searchLatitude!
                ]

        let url         = "https://dapi.kakao.com/v2/local/search/keyword.json"
        
        AF.request(url, method: .get ,parameters: parameters, encoding: URLEncoding.default, headers : headers,  interceptor: Interceptor(indicator: activityIndicator!) ).validate().responseJSON(completionHandler: { response in
            
            code = response.response?.statusCode
 
            switch response.result {
            
                case .success(let obj):
                
                do {
                        
                        print(parameters)
                        let JSONData = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                        let instanceData = try JSONDecoder().decode(KakaoAddressObject.self, from: JSONData)
                    
                    if instanceData.documents.count != self.size {
                        
                        self.moreLoadFlag = false
                        
                    }else {
                        
                        self.moreLoadFlag = true
                        
                    }
                    
                    for content in instanceData.documents {
                      
                        self.arr.append(content)
                        print(content)
                    }
                    self.tableView.dataSource = self
                    
                    DispatchQueue.main.async {
                            
                        self.tableView.delegate             = self
                        self.tableView.dataSource           = self
                        self.tableView.allowsSelection      = false
                        self.tableView.reloadData()
                    }
                    
                    self.page += 1
                    
                } catch {
                    print("error : \(error.localizedDescription)")
                    print("서버와 통신이 원활하지 않습니다. 고객센터로 문의주십시오. code : \(code!)")
                }
                
            case .failure(let err):
                
                print("error is \(String(describing: err))")
                
                if code == 400 {
                    print("400 Error.")
                    self.view.makeToast("400 Error", duration: 2.0, position: .bottom)

                } else {
                    print("Unknown Error")
                    self.view.makeToast("Error.", duration: 2.0, position: .bottom)
                }
            }
            
            self.activityIndicator!.stopAnimating()
        })
        
    }
    
    
    @IBAction func setConditionButton(_ sender: UIButton!){
        
        //선택한 버튼 글자 색 검정, 이미지 색 파랑.  -  선택되지 않은 버튼 글자 색, 이미지 색 회색
        switch sender {
        case myLocationButton:
            myLocationButton.setTitleColor(ColorBlack, for: .normal)
            myLocationButton.tintColor = Color3498DB
            mapLocationButton.setTitleColor(ColorE0E0E0, for: .normal)
            mapLocationButton.tintColor = ColorE0E0E0
            searchLatitude = userLatitude
            searchLongitude = userLongitude
            break
        case mapLocationButton:
            mapLocationButton.setTitleColor(ColorBlack, for: .normal)
            mapLocationButton.tintColor = Color3498DB
            myLocationButton.setTitleColor(ColorE0E0E0, for: .normal)
            myLocationButton.tintColor = ColorE0E0E0
            searchLatitude = mapLatitude
            searchLongitude = mapLongitude
            break
        default:
            break
        }

        arr.removeAll()
        page = 1
        getAddressList()
    }
    @objc func closeButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
