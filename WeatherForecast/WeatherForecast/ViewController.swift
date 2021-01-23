//
//  WeatherForecast
//  ViewController.swift
//
//  Created by Kyungmin Lee on 2021/01/22.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    // MARK: - Properties
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        return locationManager
    }()
    private var currentCoordinate: CLLocationCoordinate2D! {
        didSet {
            findCurrentPlacemark()
        }
    }
    private var currentAdress: Adress! {
        didSet {
            print("\(currentAdress.administrativeArea) \(currentAdress.locality)")
        }
    }
    private var currentWeather: CurrentWeather!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCurrentCoordinate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.572849&lon=126.976829&units=metric&lang=kr&appid=d581ffc8458e8085899bfe16c04fe7da") else {
            return
        }
        
        let session = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                let currentWeather: CurrentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                self.currentWeather = currentWeather
                
                DispatchQueue.main.async {
                    print("Response Done")
                    print("\(self.currentWeather.coordinate.latitude), \(self.currentWeather.coordinate.longitude)")
                    print("\(self.currentWeather.cityName)")
                    print(self.currentWeather.weather.description)
                    print("온도: \(self.currentWeather.temperature.current)")
                }
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    // MARK: - Methods
    private func requestCurrentCoordinate() {
        locationManager.startUpdatingLocation()
    }
    
    private func findCurrentPlacemark() {
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: nil) { (placemarks, error) in
            if let errorCode = error {
                print(errorCode)
                return
            }
            if let administrativeArea = placemarks?.first?.administrativeArea, let locality = placemarks?.first?.locality {
                self.currentAdress = Adress(administrativeArea: administrativeArea, locality: locality)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate Methods
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            self.currentCoordinate = currentCoordinate
        }
    }
}
