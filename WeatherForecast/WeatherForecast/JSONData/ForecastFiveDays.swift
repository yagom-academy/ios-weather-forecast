
import Foundation

struct ForecastFiveDays: Codable {
    let timeStampsCount: Int
    let list: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case timeStampsCount = "cnt"
        case list
    }
}
