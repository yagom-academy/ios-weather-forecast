import Foundation

struct Forecast: Decodable {
    private let icon: [WeatherIcon]
    private let temperature: Temperature
    private let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
        case dateTime = "dt_txt"
    }
}
