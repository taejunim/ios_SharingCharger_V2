//
//  HistoryPointSearchConditionViewController.swift
//  SharingCharger_V2
//  Description - 포인트 이력_검색조건 ViewController
//  Created by 김재연 on 2021/04/21.
//

import Foundation

protocol SearchPointHistoryProtocol {
    func searchPointConditionDelegate(data: SearchHistoryConditionObject)
}
class PointHistorySearchConditionViewController : UIViewController {
    
    var delegate: SearchPointHistoryProtocol?
    
    @IBOutlet var oneMonth: UIButton!
    @IBOutlet var threeMonth: UIButton!
    @IBOutlet var sixMonth: UIButton!
    @IBOutlet var ownPeriod: UIButton!
    
    @IBOutlet var arrow: UIImageView!       //직접선택버튼 화살표
    
    @IBOutlet var periodLabels: UIView!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    @IBOutlet var datepickerView: UIView!
    @IBOutlet var startDatepicker: UIDatePicker!
    @IBOutlet var endDatepicker: UIDatePicker!
    
    @IBOutlet var whole: UIButton!
    @IBOutlet var pointCharge: UIButton!
    @IBOutlet var use: UIButton!
    @IBOutlet var partialRefund: UIButton!
    
    @IBOutlet var desc: UIButton!
    @IBOutlet var asc: UIButton!
    
    @IBOutlet var adjustButton: UIButton!
    
    var periodButtonArray : [UIButton] = []
    var typeButtonArray : [UIButton] = []
    var sortButtonArray : [UIButton] = []
    
    let sortArray                : [String]   = ["DESC","ASC"]
    let pointArray               : [String]   = ["ALL","PURCHASE","USED","REFUND"]
    
    let buttonBorderWidth        : CGFloat!   = 1.0
    let ColorE0E0E0 : UIColor! = UIColor(named: "Color_E0E0E0")
    let Color3498DB : UIColor! = UIColor(named: "Color_3498DB")
    let ColorWhite  : UIColor! = UIColor.white
    
    let calendar                              = Calendar.current
    let date                                  = Date()
    let dateFormatter                         = DateFormatter()
    
    var count                                 = 0
    
    var startDate                             = ""
    var endDate                               = ""
    
    var selectedSort                          = 0
    var selectedType                          = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate                = PointHistoryViewController()
        
        Common.addTopButton(buttonName: "close", width: 40, height: 40, top: 15, left: 15, right: nil, bottom: nil, target: self.view, targetViewController: self)
        Common.addTopButton(buttonName: "refresh", width: 40, height: 40, top: 15, left: nil, right: -15, bottom: nil, target: self.view, targetViewController: self)
        
        
        activateView(active: false)
        
        periodButtonArray.append(oneMonth)
        periodButtonArray.append(threeMonth)
        periodButtonArray.append(sixMonth)
        periodButtonArray.append(ownPeriod)
        
        typeButtonArray.append(whole)
        typeButtonArray.append(pointCharge)
        typeButtonArray.append(use)
        typeButtonArray.append(partialRefund)
        
        sortButtonArray.append(desc)
        sortButtonArray.append(asc)
        
        dateFormatter.locale         = Locale(identifier: "ko")
        dateFormatter.dateFormat     = "yyyy-MM-dd"

        startDatepicker.locale       = Locale(identifier: "ko")
        endDatepicker.locale         = Locale(identifier: "ko")
        
        for button in self.periodButtonArray {
            button.addTarget(self, action: #selector(setPeriodButton(_:)), for: .touchUpInside)
        }
        for button in self.typeButtonArray {
            button.addTarget(self, action: #selector(setTypeButton(_:)), for: .touchUpInside)
        }
        for button in self.sortButtonArray {
            button.addTarget(self, action: #selector(setSortButton(_:)), for: .touchUpInside)
        }
        
        setPeriodButton(oneMonth)
        setSortButton(desc)
        setTypeButton(whole)
        
        Common.setButton(button: adjustButton, able: true, color: nil, radius: 7, action: #selector(adjust), target: self)
    }
    
    //적용 버튼
    @objc func adjust(sender: UIButton!) {
        print("적용")
        let searchHistoryConditionObject            = SearchHistoryConditionObject()
        searchHistoryConditionObject.startDate      = startDateLabel.text!
        searchHistoryConditionObject.endDate        = endDateLabel.text!
        searchHistoryConditionObject.sort           = sortArray[selectedSort]
        searchHistoryConditionObject.pointUsedType  = pointArray[selectedType]
        
        delegate?.searchPointConditionDelegate(data: searchHistoryConditionObject)
        self.dismiss(animated: true, completion: nil)
    }
    
    //datepicker 직접 변경시에 종료날짜가 오늘날짜보다 크거나, 시작날짜가 종료날짜보다 클때를 막는다
    @IBAction func changeDate(_ sender: UIDatePicker) {
        
        var originalDate:String                                     = ""
        
        switch sender {
        case startDatepicker :
            originalDate        = startDateLabel.text!
            startDateLabel.text = dateFormatter.string(from: sender.date)
            break
            
        case endDatepicker   :
            originalDate        = endDateLabel.text!
            endDateLabel.text   = dateFormatter.string(from: sender.date)
            break
        default:
            break
        }
        
        if(endDatepicker.date > Date()){
            
            endDatepicker.setDate(Date(), animated: true)
            endDateLabel.text   = dateFormatter.string(from: Date())
            
        }
        
        if(startDateLabel.text! > endDateLabel.text!){
            
            sender.setDate(dateFormatter.date(from: originalDate)! , animated: true)
            
            if sender == startDatepicker {
                startDateLabel.text = originalDate
            } else {
                endDateLabel.text   = originalDate
            }
            return
        }
    }
    
    //조회기간 버튼 설정
    @IBAction func setPeriodButton(_ sender: UIButton) {
        
        for index in 0...3 {
            if(index == periodButtonArray.firstIndex(of: sender)){
                Common.setButton(button: periodButtonArray[index], able: true, color: Color3498DB, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: periodButtonArray[index], borderWidth: buttonBorderWidth, borderColor: Color3498DB)
                periodButtonArray[index].setTitleColor(ColorWhite, for: .normal)
                
            } else{
                Common.setButton(button: periodButtonArray[index], able: true, color: ColorWhite, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: periodButtonArray[index], borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
                periodButtonArray[index].setTitleColor(ColorE0E0E0, for: .normal)
                
            }
        }
        onPeriodButtonClick(sender)
    }
    
    //조회기간 버튼 설정
    @IBAction func setTypeButton(_ sender: UIButton) {
        activateView(active: false)
        arrow.image = UIImage(named: "searching_condition_arrow_off")
        for index in 0...3 {
            if(index == typeButtonArray.firstIndex(of: sender)){
                Common.setButton(button: typeButtonArray[index], able: true, color: Color3498DB, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: typeButtonArray[index], borderWidth: buttonBorderWidth, borderColor: Color3498DB)
                typeButtonArray[index].setTitleColor(ColorWhite, for: .normal)
                selectedType = index
                
            } else{
                Common.setButton(button: typeButtonArray[index], able: true, color: ColorWhite, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: typeButtonArray[index], borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
                typeButtonArray[index].setTitleColor(ColorE0E0E0, for: .normal)
                
            }
        }
    }
    
    //정렬 버튼 설정
    @IBAction func setSortButton(_ sender: UIButton) {
        activateView(active: false)
        arrow.image = UIImage(named: "searching_condition_arrow_off")
        for index in 0...1 {
            if(index == sortButtonArray.firstIndex(of: sender)){
                
                Common.setButton(button: sortButtonArray[index], able: true, color: Color3498DB, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: sortButtonArray[index], borderWidth: buttonBorderWidth, borderColor: Color3498DB)
                sortButtonArray[index].setTitleColor(ColorWhite, for: .normal)
                selectedSort = index
                
            } else{
                
                Common.setButton(button: sortButtonArray[index], able: true, color: ColorWhite, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: sortButtonArray[index], borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
                sortButtonArray[index].setTitleColor(ColorE0E0E0, for: .normal)
                
            }
        }
    }
    
    //date picker view
    private func activateView(active: Bool!) {
        
        switch active {
        case true  :    datepickerView.isHidden = false
            datepickerView.visible()
            startDatepicker.setDate(dateFormatter.date(from: startDateLabel.text!)! , animated: true)
            endDatepicker.setDate(dateFormatter.date(from: endDateLabel.text!)! , animated: true)
            break
        case false :    datepickerView.isHidden = true
            self.datepickerView.gone()
            break
        default    :    break
        }
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    
    //조회기간 버튼 선택에 따른 변화
    func onPeriodButtonClick(_ range : UIButton){
        
        if(range == ownPeriod){
            arrow.isHidden = false
            count += 1
            
            if(count % 2 == 0) {
                activateView(active: false)
                arrow.image = UIImage(named: "searching_condition_arrow_off")
                
            } else {
                activateView(active: true)
                arrow.image = UIImage(named: "searching_condition_arrow")
            }
        }else{
            count = 0
            arrow.isHidden = true
            activateView(active: false)
            switch range {
            
            case oneMonth:
                startDate   = dateFormatter.string(from : calendar.date(byAdding: .month,value: -1, to: date)!)
                break
            case threeMonth:
                startDate   = dateFormatter.string(from : calendar.date(byAdding: .month,value: -3, to: date)!)
                break
            case sixMonth:
                startDate   = dateFormatter.string(from : calendar.date(byAdding: .month,value: -6, to: date)!)
                break
            default:
                break
            }
            endDate             = dateFormatter.string(from: date)
            
            startDateLabel.text = startDate
            endDateLabel.text   = endDate
        }
    }
    
    //새로고침 버튼
    @objc func refreshButton(sender: UIButton!) {
        setPeriodButton(oneMonth)
        setSortButton(desc)
        setTypeButton(whole)
    }
    
    //창 닫기 버튼
    @objc func closeButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}