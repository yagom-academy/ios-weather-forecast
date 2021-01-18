import Foundation

///온도(최소, 최대, 체감), 기압, 습도 정보
/// - actual : 실제 온도
/// - feelsLike : 체감 온도
/// - min : 최저 기온
/// - max : 최고 기온
/// - pressure : 기압
/// - humidity : 습도
struct Temperature: Codable {
    let actual: Double
    let feelsLike: Double
    let min: Double
    let max: Double
    let pressure: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case actual = "temp"
        case feelsLike = "feels_like"
        case min = "temp_min"
        case max = "temp_max"
        case pressure, humidity
    }
}
