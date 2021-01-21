import Foundation

struct FiveDayWeather: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City
    
    struct List: Decodable {
        let coordinatedUniversalTime: Date
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let pop: Double
        let rain: Rain
        let snow: Snow
        let sys: Sys
        let dtTxt: String
        
        enum CodingKeys: String, CodingKey {
            case coordinatedUniversalTime = "dt"
            case main, weather, clouds, wind, pop, rain, snow, sys
            case dtTxt = "dt_txt"
        }
        
        struct LocationCoordinate: Decodable {
            let longitude: Double
            let latitude: Double
            
            enum CodingKeys: String, CodingKey {
                case longitude = "lon"
                case latitude = "lat"
            }
        }
        
        struct Main: Decodable {
            let temperature: Double
            let feelsLike: Double
            let minTemperature: Double
            let maxTemperature: Double
            let pressure: Int
            let airPressureOfSeaLevel: Int
            let airPressureOfGround: Int
            let humidity: Int
            let tempKf: Double
           
            var temperatureInCelsius: Double {
                let convertedValue = (self.temperature - 273)
                return round(convertedValue * 10) / 10
            }
            
            var feelsLikeInCelsius: Double {
                let convertedValue = (self.feelsLike - 273)
                return round(convertedValue * 10) / 10
            }
            
            var minTemperatureInCelsius: Double {
                let convertedValue = (self.minTemperature - 273)
                return round(convertedValue * 10) / 10
            }
            
            var maxTemperatureInCelsius: Double {
                let convertedValue = (self.maxTemperature - 273)
                return round(convertedValue * 10) / 10
            }
            
            enum CodingKeys: String, CodingKey {
                case temperature = "temp"
                case pressure, humidity
                case feelsLike = "feels_like"
                case minTemperature = "temp_min"
                case maxTemperature = "temp_max"
                case airPressureOfSeaLevel = "sea_level"
                case airPressureOfGround = "grnd_level"
                case tempKf = "temp_kf"
            }
        }
        
        struct Weather: Decodable {
            let stateID: Int
            let main: String
            let description: String
            let iconID: String
            
            enum CodingKeys: String, CodingKey {
                case stateID = "id"
                case main, description
                case iconID = "icon"
            }
        }
        
        struct Clouds: Decodable {
            let allOver: Int
            
            enum CodingKeys: String, CodingKey {
                case allOver = "all"
            }
        }
        
        struct Wind: Decodable {
            let speed: Double
            let degree: Int
            
            enum CodingKeys: String, CodingKey {
                case speed
                case degree = "deg"
            }
        }
        
        struct Rain: Decodable {
            let threeHour: Double
            
            enum CodingKeys: String, CodingKey {
                case threeHour = "3h"
            }
        }
        
        struct Snow: Decodable {
            let threeHour: Double
            
            enum CodingKeys: String, CodingKey {
                case threeHour = "3h"
            }
        }
        
        struct Sys: Decodable {
            let pod: String
        }
    }
    
    struct City: Decodable {
        let id: Int
        let name: String
        let locationCoordinate: LocationCoordinate
        let countryCode: String
        let timezone: Int
        let sunrise: Int
        let sunset: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name, timezone, sunrise, sunset
            case locationCoordinate = "coord"
            case countryCode = "country"
        }
    }
}
