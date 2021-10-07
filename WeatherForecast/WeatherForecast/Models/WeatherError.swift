//
//  WeatherError.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/29.
//

import Foundation

protocol WeatherCodable {}

extension Int: WeatherCodable {}
extension String: WeatherCodable {}

struct WeatherError: Decodable, ErrorMessageProtocol {
    let cod: WeatherCodable
    let message: String
    
    var errorMessage: String {
        return message
    }
    
    enum CodingKeys: CodingKey {
        case cod, message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let stringCod = try? container.decode(String.self, forKey: .cod) {
            cod = stringCod
        } else {
            cod = try container.decode(Int.self, forKey: .cod)
        }
        message = try container.decode(String.self, forKey: .message)
    }
}
