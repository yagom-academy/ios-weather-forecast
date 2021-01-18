import Foundation

struct ForecastFiveDays: Codable {
    let numberOfTimeStamp: Int
    let forecastList: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case numberOfTimeStamp = "cnt"
        case forecastList = "list"
    }
}
