//
//  Decodable+Extension.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/28.
//

import Foundation

extension Decodable {
    func parse<T: Decodable>(to destinationType: T.Type) -> Result<T, ParsingError> {
        let jsonDecoder = JSONDecoder()
        guard let data = self as? Data else {
            return .failure(.dataConvertError)
        }
        guard let decodedData = try? jsonDecoder.decode(destinationType, from: data) else {
            return .failure(.decodingError)
        }
        return .success(decodedData)
    }
}
