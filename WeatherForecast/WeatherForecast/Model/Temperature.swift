import Foundation

struct Temperature: Decodable {
    private let average: Double
    private let minimum: Double
    private let maximum: Double
    
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
