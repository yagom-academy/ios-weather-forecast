
import Foundation

struct CurrentWeather: Codable {
    let city: String
    let weather: [Weather]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case weather
        case temperature = "main"
    }
}
