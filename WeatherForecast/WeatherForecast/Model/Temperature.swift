import Foundation

struct Temperature: Codable {
    let average: Double
    let minimum: Double
    let maximum: Double
    
    var celsiusAverage: Double {
        return UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.average)
    }
    
    var celsiusMinimum: Double {
        return UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.minimum)
    }
    
    var celsiusMaximum: Double {
        return UnitTemperature.celsius.converter.value(fromBaseUnitValue: self.maximum)
    }
    
    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case minimum = "temp_min"
        case maximum = "temp_max"
    }
}
