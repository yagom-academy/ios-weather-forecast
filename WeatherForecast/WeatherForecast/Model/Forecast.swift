import Foundation

struct Forecast: Decodable {
    let icon: [WeatherIcon]
    let temperature: Temperature
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
        case dateTime = "dt_txt"
    }
}
