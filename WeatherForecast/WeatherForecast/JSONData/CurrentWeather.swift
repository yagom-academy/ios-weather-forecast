
import Foundation

struct CurrentWeather: Codable {
    let country: String
    let city: String
    let weather: [Weather]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case country
        case city = "name"
        case weather
        case temperature = "main"
    }
}
