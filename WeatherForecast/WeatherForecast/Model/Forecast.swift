
import Foundation

struct Forecast: Decodable {
    let dateTime: String
    let weather: [Weather]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt_txt"
        case weather
        case temperature = "main"
    }
}
