import Foundation

struct CurrentWeather: Decodable {
    let icon: [WeatherIcon]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
    }
}
