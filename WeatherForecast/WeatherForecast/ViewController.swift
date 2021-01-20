import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    private let apiKey: String = "02337d7f6423f1596383c1797c318936"
    private var latitude: Double = 37.68382
    private var longitude: Double = 126.742401
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchForLocationInformation()
    }
    
    func searchForLocationInformation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locationManager.location?.coordinate else {
            print("현재 위치 위경도 값을 받아올 수 없습니다.")
            return
        }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치허용을 누르지 않아 정보를 받아올 수 없습니다.")
    }
}
