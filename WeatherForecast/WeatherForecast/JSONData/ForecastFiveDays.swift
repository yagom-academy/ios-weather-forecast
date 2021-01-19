
import Foundation

struct ForecastFiveDays: Decodable {
    let timeStampsCount: Int
    let list: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        case timeStampsCount = "cnt"
        case list
    }
}
