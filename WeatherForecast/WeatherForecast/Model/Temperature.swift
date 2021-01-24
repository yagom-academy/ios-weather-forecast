
import Foundation

struct Temperature: Decodable {
    let current: Double
    let feelsLike: Double
    let min: Double
    let max: Double
    let pressure: Double
    let humidity: Double
    
    var currentCelsius: Double {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.current)
        return celsius
    }
    
    var minCelsius: Double {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.min)
        return celsius
    }
    
    var maxCelsius: Double {
        let celsius = UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.max)
        return celsius
    }
    
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case feelsLike = "feels_like"
        case min = "temp_min"
        case max = "temp_max"
        case pressure, humidity
    }
}
