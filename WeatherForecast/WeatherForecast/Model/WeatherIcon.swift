import Foundation

struct WeatherIcon: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
