//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation


private func checkStatusCode(response: HTTPURLResponse) -> Bool {
    switch response.statusCode {
    case 200:
        return true
    case 400:
        print("잘못된 요청입니다.")
        return false
    case 401:
        print("인증이 잘못되었습니다.")
        return false
    case 403:
        print("해당 정보에 접근할 수 없습니다. ")
        return false
    case 500...:
        print("서버에러")
        return false
    default:
        print("네트워크 요청을 확인 해 보세요")
        return false
    }
}
