
import Foundation

struct Temperature: Decodable {
    let currentMeasurement: Double
    let minimumMeasurement: Double
    let maximumMeasurement: Double
    
    private enum CodingKeys: String, CodingKey {
        case currentMeasurement = "temp"
        case minimumMeasurement = "temp_min"
        case maximumMeasurement = "temp_max"
    }
}
