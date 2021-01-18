import Foundation

struct Forecast: Codable {
    let dataTimeText: String
    let temperature: Temperature
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dataTimeText = "dt_txt"
        case temperature = "main"
        case weather
    }
}
