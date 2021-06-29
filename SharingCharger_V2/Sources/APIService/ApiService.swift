//
//  ApiService.swift
//  SharingCharger_V2
//
//  Created by KJ on 2021/05/31.
//

import UIKit
import Alamofire

class ApiService {
    
    struct Results: Codable {
        var status: String  //API 호출 결과 상태
        var message: String //API 호출 결과 메시지
        var data: [String : String]  //API 호출 결과 데이터
    }
    
    //API 호출 공통함수 - 호출 예) APIService().request("Path URL", "요청 메소드", parameters[])
    func request(_ path: String, _ method: String, _ parameters: [String: Any], completionHandler: @escaping (Results) -> Void) {
        
        //let baseUrl = "http://api.msac.co.kr" //Base URL
        let baseUrl = "https://d713beab-d68b-434e-b8f6-4061ee69ea87.mock.pstmn.io"  //Test URL
        let requestUrl = baseUrl + path //Request URL
        
        //메소드 별 API 요청
        if method == "GET" {
            requestGet(requestUrl, parameters) { (result) in
                completionHandler(result)
            }
        }
        else if method == "POST" {
            requestPost(requestUrl, parameters) { (result) in
                completionHandler(result)
            }
        }
    }
    
    //GET Method
    func requestGet(_ requestUrl: String, _ parameters: [String: Any], completionHandler: @escaping (Results) -> Void) {

        let request = AF.request(requestUrl, method: .get, parameters: parameters)  //API 호출

        request.responseJSON { (response) in
            switch response.result {
            
            //API 호출 성공
            case .success(let object):
                do {
                    let jsonObject = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)    //JSON Parsing
                    let jsonData = try JSONDecoder().decode(Results.self, from: jsonObject)
                    
                    completionHandler(jsonData)
                } catch {
                    let results = Results(status: "error", message: "Not Found", data: ["":""])
                    completionHandler(results)
                    
                    print(error.localizedDescription)
                }
            //API 호출 실패
            case .failure(let error):
                let results = Results(status: "fail", message: "Server Error", data: ["":""])
                completionHandler(results)
                
                print(error.localizedDescription)
                
            }
        }
    }

    //POST Method
    func requestPost(_ requestUrl: String, _ parameters: [String: Any], completionHandler: @escaping (Results) -> Void) {

        let request = AF.request(requestUrl, method: .post, parameters: parameters, encoding: URLEncoding.httpBody) //API 호출

        request.responseJSON { (response) in
            switch response.result {
            
            //API 호출 성공
            case .success(let object):
                do {
                    let jsonObject = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)    //JSON Parsing
                    let jsonData = try JSONDecoder().decode(Results.self, from: jsonObject)
                } catch {
                    let results = Results(status: "error", message: "Not Found", data: ["":""])
                    completionHandler(results)

                    print(error.localizedDescription)
                }
            //API 호출 실패
            case .failure(let error):
                let results = Results(status: "fail", message: "Server Error", data: ["":""])
                completionHandler(results)
                
                print(error.localizedDescription)
            }
        }
    }
}
