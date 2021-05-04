//
//  ChargerSearchConditionViewController.swift
//  SharingCharger_V2
//
//  Created by 조유영 on 2021/04/21.
//  Description - 메인화면 -> 충전기 검색 조건
//  Copyright © 2021 metisinfo. All rights reserved.
//

import Foundation

class ChargerSearchConditionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var totalTimeLabel: UILabel!
    
    @IBOutlet var instantCharge: UIButton!
    @IBOutlet var reservationCharge: UIButton!
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var chargeStartTimeView: UIView!
    @IBOutlet var chargePeriodView: UIView!
    @IBOutlet var rangeView: UIView!
    @IBOutlet var typeView: UIView!
    
    @IBOutlet var chargeStartTimeLabel: UILabel!
    @IBOutlet var chargePeriodLabel: UILabel!
    @IBOutlet var rangeLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var chargeStartTimePicker: UIDatePicker!
    @IBOutlet var chargePeriodPicker: UIPickerView!
    @IBOutlet var rangePicker: UIPickerView!
    @IBOutlet var typePicker: UIPickerView!
    
    @IBOutlet var chargeStartTimePickerView: UIView!
    @IBOutlet var chargePeriodPickerView: UIView!
    @IBOutlet var rangePickerView: UIView!
    @IBOutlet var typePickerView: UIView!
    
    
    private var chargingTimeArray: [String] = []
    private var rangeArray: [String] = ["전체", "3 km", "10 km", "40 km"]
    private var typeArray: [String] = ["BLE", "MODEM"]
    
    let buttonBorderWidth        : CGFloat!   = 1.0
    let ColorE0E0E0 : UIColor! = UIColor(named: "Color_E0E0E0")
    let Color3498DB : UIColor! = UIColor(named: "Color_3498DB")
    let ColorWhite : UIColor! = UIColor.white
    let ColorBlack : UIColor! = UIColor.black
    
    override func viewDidLoad() {
        Common.addTopButton(buttonName: "close", width: 40, height: 40, top: 15, left: 15, right: nil, bottom: nil, target: self.view, targetViewController: self)
        Common.addTopButton(buttonName: "refresh", width: 40, height: 40, top: 15, left: nil, right: -15, bottom: nil, target: self.view, targetViewController: self)
        Common.setButton(button: confirmButton, able: true, color: nil, radius: 7, action: #selector(confirm), target: self)
        Common.setButton(button: instantCharge, able: true, color: nil, radius: nil , action: #selector(selectCharge), target: self)
        Common.setButton(button: reservationCharge, able: true, color: nil, radius: nil , action: #selector(selectCharge), target: self)
        
        selectCharge(sender: instantCharge)
        
        chargeStartTimePickerView.gone()
        
        chargingTimeArray.append("30분")
        for i in 1 ... 10 {
            
            chargingTimeArray.append("\(i)시간")
            
            if i < 10 {
                chargingTimeArray.append("\(i)시간 30분")
            }
        }
        
        chargePeriodPickerView.gone()
        
        chargePeriodPicker.backgroundColor = .white
        chargePeriodPicker.delegate = self
        chargePeriodPicker.dataSource = self
        chargePeriodPicker.selectRow(7, inComponent: 0, animated: false)
        
        rangePickerView.gone()
        
        rangePicker.backgroundColor = .white
        rangePicker.delegate = self
        rangePicker.dataSource = self
        rangePicker.selectRow(1, inComponent: 0, animated: false)
        
        typePickerView.backgroundColor = UIColor.white
        typePickerView.gone()
        
        typePicker.backgroundColor = .white
        typePicker.delegate = self
        typePicker.dataSource = self
        typePicker.selectRow(1, inComponent: 0, animated: false)
        
        
        addViewGestureRecognizer(action: #selector(controlView), view: chargeStartTimeView)
        addViewGestureRecognizer(action: #selector(controlView), view: chargePeriodView)
        addViewGestureRecognizer(action: #selector(controlView), view: rangeView)
        addViewGestureRecognizer(action: #selector(controlView), view: typeView)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == chargePeriodPicker {
            return chargingTimeArray.count
            
        } else if pickerView == rangePicker {
            return rangeArray.count
            
        } else if pickerView == typePicker {
            return typeArray.count
            
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == chargePeriodPicker {
            
            return chargingTimeArray[row]
            
        } else if pickerView == rangePicker {
            
            return rangeArray[row]
            
        } else if pickerView == typePicker {
            return typeArray[row]
            
        } else {
            
            return ""
        }
    }
    //pickerView 에서 값 변경시 Event, datePicker는 별도로 처리함.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        if pickerView == chargePeriodPicker {
            chargePeriodLabel.text = chargingTimeArray[row]
           // timeChanged()
            
        } else if pickerView == rangePicker {
            
            rangeLabel.text = rangeArray[row]
        } else if pickerView == typePicker {
            typeLabel.text = typeArray[row]
            
        } else {
        }
    }
    private func activateView(active: Bool!) {
        
        /*   switch active {
         case true  :    datepickerView.isHidden = false
         datepickerView.visible()
         //startDatePicker.setDate(dateFormatter.date(from: startDateLabel.text!)! , animated: true)
         //endDatePicker.setDate(dateFormatter.date(from: endDateLabel.text!)! , animated: true)
         break
         case false :    datepickerView.isHidden = true
         self.datepickerView.gone()
         break
         default    :    break
         }*/
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        
    }
    @objc func selectCharge(sender: UIButton!) {
        switch sender {
        case instantCharge:
            print("즉시 충전")
            Common.setButton(button: instantCharge, able: true, color: Color3498DB, radius: 0, action: nil, target: self)
            Common.setButtonBorder(button: instantCharge, borderWidth: buttonBorderWidth, borderColor: Color3498DB)
            instantCharge.setTitleColor(ColorWhite, for: .normal)
            Common.setButton(button: reservationCharge, able: true, color: ColorWhite, radius: 0, action: nil, target: self)
            Common.setButtonBorder(button: reservationCharge, borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
            reservationCharge.setTitleColor(ColorE0E0E0, for: .normal)
            chargeStartTimeView.isUserInteractionEnabled = false
            chargeStartTimeLabel.textColor = ColorE0E0E0
            break
        case reservationCharge:
            print("예약 충전")
            Common.setButton(button: reservationCharge, able: true, color: Color3498DB, radius: 0, action: nil, target: self)
            Common.setButtonBorder(button: reservationCharge, borderWidth: buttonBorderWidth, borderColor: Color3498DB)
            reservationCharge.setTitleColor(ColorWhite, for: .normal)
            Common.setButton(button: instantCharge, able: true, color: ColorWhite, radius: 0, action: nil, target: self)
            Common.setButtonBorder(button: instantCharge, borderWidth: buttonBorderWidth, borderColor: ColorE0E0E0)
            instantCharge.setTitleColor(ColorE0E0E0, for: .normal)
            
            chargeStartTimeView.isUserInteractionEnabled = true
            chargeStartTimeLabel.textColor = ColorBlack
            break
        default:
            break
        }
    }
    @objc func controlView(sender : UITapGestureRecognizer){
        
        var view = chargeStartTimePickerView
        
        if sender.view == chargeStartTimeView {
            view = chargeStartTimePickerView
        } else if sender.view == chargePeriodView {
            view = chargePeriodPickerView
        } else if sender.view == rangeView {
            view = rangePickerView
        } else {
            view = typePickerView
        }

        if view!.isGone {
            view!.isHidden = false
            view!.visible()
        } else {
            view!.isHidden = true
            view!.gone()
        }
        
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }
    func addViewGestureRecognizer(action : Selector, view : UIView){
        let gesture = UITapGestureRecognizer(target: self, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    @objc func confirm(sender: UIButton!) {
        print("확인")
        self.dismiss(animated: true, completion: nil)
    }
    @objc func refreshButton(sender: UIButton!) {
        selectCharge(sender: instantCharge)
    }
    @objc func closeButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
