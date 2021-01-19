
import Foundation

struct Temperature: Codable {
    let current: Double
    let feelsLike: Double
    let min: Double
    let max: Double
    let pressure: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case feelsLike = "feels_like"
        case min = "temp_min"
        case max = "temp_max"
        case pressure, humidity
    }
}
