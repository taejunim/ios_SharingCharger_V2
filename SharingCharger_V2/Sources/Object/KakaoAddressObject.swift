//
//  KakaoAddressObject.swift
//  SharingCharger_V2
//  Description - 카카오 주소 검색 API 응답을 처리하기 위한 Object
//  Created by 조유영 on 2021/05/03.
//

class KakaoAddressObject: Codable {
    
    var documents: [Place]
    
    struct Place: Codable {
        var id                   : String?
        var place_name           : String?
        var category_name        : String?
        var category_group_code  : String?
        var category_group_name  : String?
        var phone                : String?
        var address_name         : String?
        var road_address_name    : String?
        var x                    : String?
        var y                    : String?
        var place_url            : String?
        var distance             : String?
    }
    
}
