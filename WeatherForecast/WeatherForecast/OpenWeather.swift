import Foundation

struct OpenWeather {
    let apiKey = "56e736f23fc45bb2308686053888de92"
    let urlSession = URLSession(configuration: .default)
    let jsonDecoder = JSONDecoder()
    
    func currentWeather(latitude: Double, longitude: Double) {
        var requestUrl = "https://api.openweathermap.org/data/2.5/weather"
        requestUrl += "?lat=\(latitude)"
        requestUrl += "&lon=\(longitude)"
        requestUrl += "&appid=\(apiKey)"
        requestUrl += "&units=metric"
        
        guard let url = URL(string: requestUrl) else {
            return
        }
        let dataTask = urlSession.dataTask(with: url) { (data, url, error) in
            guard error == nil else {
                return
            }
            
            do {
                if let receivedData = data {
                    let decodedData = try jsonDecoder.decode(CurrentWeather.self, from: receivedData)
                    print(decodedData)
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    func forecastWeather(latitude: Double, longitude: Double) {
        var requestUrl = "https://api.openweathermap.org/data/2.5/forecast"
        requestUrl += "?lat=\(latitude)"
        requestUrl += "&lon=\(longitude)"
        requestUrl += "&appid=\(apiKey)"
        requestUrl += "&units=metric"
        
        guard let url = URL(string: requestUrl) else {
            return
        }
        let dataTask = urlSession.dataTask(with: url) { (data, url, error) in
            guard error == nil else {
                return
            }
            
            do {
                if let receivedData = data {
                    let decodedData = try jsonDecoder.decode(ForecastWeather.self, from: receivedData)
                    print(decodedData)
                }
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}
