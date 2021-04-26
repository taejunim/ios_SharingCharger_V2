//
//  SearchingPointHistoryConditionViewController.swift
//  SharingCharger_V2
//  Description - 포인트 이력_검색조건 ViewController
//  Created by 김재연 on 2021/04/21.
//

import Foundation

class SearchingPointHistoryConditionViewController : UIViewController {
    
    @IBOutlet var oneMonth: UIButton!
    @IBOutlet var threeMonth: UIButton!
    @IBOutlet var sixMonth: UIButton!
    @IBOutlet var ownPeriod: UIButton!
    
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
    
    
    let buttonBorderWidth        : CGFloat!   = 1.0
    let ColorE0E0E0 : UIColor! = UIColor(named: "Color_E0E0E0")
    let Color3498DB : UIColor! = UIColor(named: "Color_3498DB")
    let ColorWhite  : UIColor! = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @objc func adjust(sender: UIButton!) {
        print("적용")
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func setTypeButton(_ sender: UIButton) {
        
        for index in 0...3 {
            if(index == typeButtonArray.firstIndex(of: sender)){
                Common.setButton(button: typeButtonArray[index], able: true, color: Color3498DB, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: typeButtonArray[index], borderWidth: buttonBorderWidth, borderColor: Color3498DB)
                typeButtonArray[index].setTitleColor(ColorWhite, for: .normal)
                
            } else{
                Common.setButton(button: typeButtonArray[index], able: true, color: ColorWhite, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: typeButtonArray[index], borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
                typeButtonArray[index].setTitleColor(ColorE0E0E0, for: .normal)
                
            }
        }
        
    }
    
    @IBAction func setSortButton(_ sender: UIButton) {
        
        for index in 0...1 {
            if(index == sortButtonArray.firstIndex(of: sender)){
                
                Common.setButton(button: sortButtonArray[index], able: true, color: Color3498DB, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: sortButtonArray[index], borderWidth: buttonBorderWidth, borderColor: Color3498DB)
                sortButtonArray[index].setTitleColor(ColorWhite, for: .normal)
                //selectedSort = index
                
            } else{
                
                Common.setButton(button: sortButtonArray[index], able: true, color: ColorWhite, radius: 0, action: nil, target: self)
                Common.setButtonBorder(button: sortButtonArray[index], borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
                sortButtonArray[index].setTitleColor(ColorE0E0E0, for: .normal)
                
            }
        }
        
    }
    
    private func activateView(active: Bool!) {
        
        switch active {
        case true  :    datepickerView.isHidden = false
            datepickerView.visible()
            //startDatePicker.setDate(dateFormatter.date(from: startDateLabel.text!)! , animated: true)
            //endDatePicker.setDate(dateFormatter.date(from: endDateLabel.text!)! , animated: true)
            break
        case false :    datepickerView.isHidden = true
            self.datepickerView.gone()
            break
        default    :    break
        }
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        
    }
    func onPeriodButtonClick(_ range : UIButton){
        
        if(range == ownPeriod){
            activateView(active: true)
        }else{
            activateView(active: false)
            /*switch range {
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
             endDateLabel.text   = endDate*/
        }
    }
    @objc func refreshButton(sender: UIButton!) {
        setPeriodButton(oneMonth)
        setSortButton(desc)
        setTypeButton(whole)
    }
    @objc func closeButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
