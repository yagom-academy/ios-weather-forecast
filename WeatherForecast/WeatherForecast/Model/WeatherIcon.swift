import Foundation

struct WeatherIcon: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "icon"
    }
}
