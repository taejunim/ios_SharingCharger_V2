//
//  UserApiService.swift
//  SharingCharger_V2
//
//  Created by KJ on 2021/05/28.
//

class UserApiService {
    
    let apiService = ApiService()   //API Service
    
    struct LoginData {
        var token: String   //토큰 키
        var username: String    //사용자 명
        var email: String   //이메일
        var phonenumber: String //전화번호
    }
    
    //로그인 API 호출
    func login(_ parameters: [String: Any], completionHandler: @escaping (String, String) -> Void) {
        
        apiService.request("/user/v1/login", "POST", parameters) { (result) in
            completionHandler(result.status, result.message)
            //let email: String = result.data["email"]!
            //print("Token : \(email)")
        }
    }
    
    //회원가입 API 호출
    func signUp(_ parameters: [String: Any], completionHandler: @escaping (String, String) -> Void) {
        
        apiService.request("/user/v1/signup", "POST", parameters) { (result) in
            completionHandler(result.status, result.message)
            
        }
        
//            if let data = result["data"] as? [String: Any] {
//
//                let token = data["token"] as! String
//
//                print("Token : \(token)")
//            }
    }
}
