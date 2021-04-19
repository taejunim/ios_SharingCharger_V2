//
//  Common.swift
//  SharingCharger_V2
//  Description - 공통 함수 작업
//  Created by 조유영 on 2021/04/06.
//
import Toast_Swift
import UIKit
import MaterialComponents.MaterialBottomSheet

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
    
    // keyboard 설정 - 뷰 터치시 키보드 내리기
    // @param  - UIView
    // @return - void
    static func setKeyboard(view : UIView) {
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    // Button able/disable, 색, 모서리 둥글게, Event 설정
    // @param  -
    // @return - void
    static func setButton(button : UIButton, able : Bool, color : UIColor?, radius : CGFloat?, action : Selector?, target : Any?){
        
        //버튼색
        if(color != nil){
            button.layer.backgroundColor = color?.cgColor
        }
        //코너 둥근 정도
        if(radius != nil){
            button.layer.cornerRadius = radius!
        }
        //버튼 Event
        if(action != nil){
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        
        //버튼 활성화 / 비활성화
        if able {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
        
    }
    
    // Button 테두리 두께, 색 설정
    // @param  - 
    // @return - void
    static func setButtonBorder(button : UIButton, borderWidth : CGFloat, borderColor : UIColor){
        
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
    }
    
    // NavigationBar Show / Hide
    // @param  - NavigationController , Bool
    // @return - void
    static func showNavigationController(navigationController : UINavigationController!, show : Bool){
        
        if(show){
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.tintColor = UIColor.black  //백버튼 검은색으로
            navigationController?.navigationBar.backItem?.title = ""       //백버튼 텍스트 제거
            navigationController?.navigationBar.barTintColor = .white      //navigationBar 배경 흰색으로
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
    }
    
    // Label Event 연결
    // @param  - UIViewController , Selector , label
    // @return - void
    static func addGestureRecognizer(viewController : UIViewController, action : Selector, label : UILabel){
        
        let gesture = UITapGestureRecognizer(target: viewController, action: action)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
    }
    
    // Navigation Controller rightMenu 추가
    // @param  -
    // @return - UIBarButtonItem
    static func addRightMenu(imageName : String , action : Selector , menuSize : CGSize, viewController : UIViewController) -> UIBarButtonItem{
        
        let renderer = UIGraphicsImageRenderer(size : menuSize)
        let image = UIImage(named: imageName)
        let rightMenuImage = renderer.image{_ in image!.draw(in: CGRect(origin: .zero, size: menuSize))}
        
        let rightBarButton = UIBarButtonItem.init(image: rightMenuImage ,style: .done , target: viewController, action: action)
        
        return rightBarButton
    }
    
    // 이력조회 bottomeSheet 생성
    // @param  -
    // @return - UIBarButtonItem
    static func createHistorySearchCondition(rootViewController : UIViewController, sheetViewController : UIViewController) -> MDCBottomSheetController {
        
        let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: sheetViewController)
        bottomSheet.preferredContentSize = CGSize(width: rootViewController.view.frame.size.width, height: rootViewController.view.frame.size.height)
        
        let shapeGenerator = MDCCurvedRectShapeGenerator(cornerSize: CGSize(width: 15, height: 15))
        bottomSheet.setShapeGenerator(shapeGenerator, for: .preferred)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .extended)
        bottomSheet.setShapeGenerator(shapeGenerator, for: .closed)
        
        return bottomSheet
    }
    
    // 팝업 - 검색조건, 예약 팝업 상단 버튼 추가
    // @param  -
    // @return - UIViewController
    static func addTopButton(buttonName: String?, width: CGFloat?, height: CGFloat?, top: CGFloat?, left: CGFloat?, right: CGFloat?, bottom: CGFloat?, target: AnyObject, targetViewController: UIViewController) {
        
        let button = CustomButton(type: .system)
        
        targetViewController.view.addSubview(button)
        
        button.setAttributes(buttonName: buttonName, width: width, height: height, top: top, left: left, right: right, bottom: bottom, target: target, targetViewController: targetViewController)
    }
}
