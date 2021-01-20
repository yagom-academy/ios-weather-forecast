import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let cityID: Int
    let cityName: String
    let weatherList: [Weather]
    let temperature: Temperature
    
    var weather: Weather? {
        return weatherList.first
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case cityID = "id"
        case cityName = "name"
        case temperature = "main"
        case weatherList = "weather"
    }
}
