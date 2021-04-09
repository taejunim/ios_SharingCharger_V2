//
//  Common.swift
//  SharingCharger_V2
//  Description - 공통 함수 작업
//  Created by 조유영 on 2021/04/06.
//
import Toast_Swift
class Common {
    
    // Toast Message 띄우기
    // @param  - UIView(view), String (message)
    // @return - void
    static func showToast(view : UIView , message : String!){
        view.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    // TextField 공백 체크
    // @param  - textField
    // @return - 공백 아닐 때  -> textField text
    // @return - 공백일 경우   -> nil
    static func isEmptyTextField(textField : UITextField) -> String? {
        let whitespace = CharacterSet.whitespaces
        
        if !textField.text!.trimmingCharacters(in: whitespace).isEmpty {
            return textField.text
        } else {
            return nil
        }
    }
    
    // keyboard 설정
    // 뷰 터치시 키보드 내리기
    // @param  - UIView
    // @return - void
    static func setKeyboard(view : UIView) {
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
