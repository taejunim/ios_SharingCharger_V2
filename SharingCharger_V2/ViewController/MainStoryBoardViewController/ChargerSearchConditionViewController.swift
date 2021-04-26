//
//  ChargerSearchConditionViewController.swift
//  SharingCharger_V2
//
//  Created by 조유영 on 2021/04/21.
//  Description - 메인화면 -> 충전기 검색 조건
//  Copyright © 2021 metisinfo. All rights reserved.
//

import Foundation

class ChargerSearchConditionViewController: UIViewController {
    
    @IBOutlet var totalTimeLabel: UILabel!
    
    @IBOutlet var instantCharge: UIButton!
    @IBOutlet var reservationCharge: UIButton!
    
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
    
    override func viewDidLoad() {
        Common.addTopButton(buttonName: "close", width: 40, height: 40, top: 15, left: 15, right: nil, bottom: nil, target: self.view, targetViewController: self)
        Common.addTopButton(buttonName: "refresh", width: 40, height: 40, top: 15, left: nil, right: -15, bottom: nil, target: self.view, targetViewController: self)
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
    @objc func refreshButton(sender: UIButton!) {
        //setPeriodButton(oneMonth)
        //setSortButton(desc)
    }
    @objc func closeButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
