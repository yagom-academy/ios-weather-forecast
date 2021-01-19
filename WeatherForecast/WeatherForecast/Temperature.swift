import Foundation

struct Temperature: Codable {
    let average: Double
    let minimum: Double
    let maximum: Double
    
    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case minimum = "temp_min"
        case maximum = "temp_max"
    }
}
