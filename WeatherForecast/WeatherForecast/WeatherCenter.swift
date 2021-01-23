import Foundation

struct WeatherCenter {
    let apiKey = "56e736f23fc45bb2308686053888de92"
    let urlSession = URLSession(configuration: .default)
    let jsonDecoder = JSONDecoder()
    let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func currentWeather(latitude: Double, longitude: Double, completionHandler: @escaping (CurrentWeather?, URLResponse?, Error?) -> Void) {
        let currentWeatherURL = baseURL + "/weather"
        var currentComponent = URLComponents(string: currentWeatherURL)
        let lat = URLQueryItem(name: "lat", value: "\(latitude)")
        let lon = URLQueryItem(name: "lon", value: "\(longitude)")
        let appid = URLQueryItem(name: "appid", value: apiKey)
        let units = URLQueryItem(name: "units", value: "metric")
        
        currentComponent?.queryItems = [lat, lon, appid, units]
        
        guard let url = currentComponent?.url else {
            return
        }

        let dataTask = urlSession.dataTask(with: url) { data, url, error in
            guard error == nil else {
                completionHandler(nil, url, error)
                return
            }
            
            do {
                if let receivedData = data {
                    let decodedData = try jsonDecoder.decode(CurrentWeather.self, from: receivedData)
                    completionHandler(decodedData, url, error)
                }
            } catch {
                completionHandler(nil, url, error)
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func forecastWeather(latitude: Double, longitude: Double, completionHandler: @escaping (ForecastWeather?, URLResponse?, Error?) -> Void) {
        let forecastWeatherURl = baseURL + "/forecast"
        var forecastComponent = URLComponents(string: forecastWeatherURl)
        let lat = URLQueryItem(name: "lat", value: "\(latitude)")
        let lon = URLQueryItem(name: "lon", value: "\(longitude)")
        let appid = URLQueryItem(name: "appid", value: apiKey)
        let units = URLQueryItem(name: "units", value: "metric")
        
        forecastComponent?.queryItems = [lat, lon, appid, units]
        
        guard let url = forecastComponent?.url else {
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, url, error in
            guard error == nil else {
                completionHandler(nil, url, error)
                return
            }
            
            do {
                if let receivedData = data {
                    let decodedData = try jsonDecoder.decode(ForecastWeather.self, from: receivedData)
                    completionHandler(decodedData, url, error)
                }
            } catch {
                completionHandler(nil, url, error)
                print(error)
            }
        }
        dataTask.resume()
    }
}
