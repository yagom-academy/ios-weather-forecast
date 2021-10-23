## iOS 커리어 스타터 캠프

# ☀️ 날씨 정보 프로젝트
**기 간 : 2021.09.27 ~ 2021.10.08**  
**팀 원 : 승기([ohsg0226](https://github.com/ohsg0226)), 날라([jazz-ing](https://github.com/jazz-ing))**

### Index
[STEP-1](#STEP-1-모델-타입-및-네트워킹-타입-구현)  
[STEP-2](#STEP-2-위치정보-확인-및-날씨-API-호출)

## STEP-1 모델 타입 및 네트워킹 타입 구현


### 🍎 적용 개념
#### 1. 네트워킹 타입 -> URLSession 활용
- 라이브러리 없이 URLSession을 활용하여 네트워킹 타입을 구현
<details><summary>구현 코드</summary><div markdown="1">

```swift=
typealias SessionResult = (Result<Data, NetworkError>) -> ()

class NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: URLRequest, completion: @escaping SessionResult) {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestFail))
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                      completion(.failure(.failedStatusCode))
                      return
                  }
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
```
</div></details>

#### 2. Mock객체
- URLSessionProtocol과 MockURLSession을 만들어 실제 네트워크 통신을 하지 않은 상태에서
네트워킹 타입이 목적대로 동작하는지 확인하는 테스트 코드 구현

<details><summary>구현 코드</summary><div markdown="1">

```swift=
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }

class NetworkManager<T: TargetType> {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    // ...
}

// test code
func test_MockURLSession을통해_Mock통신을성공했을때_원하는데이터가전달된다() {
    // given
    let path = Bundle(for: type(of: self)).path(forResource: "CurrentWeather", ofType: "json")
    let jsonFile = try! String(contentsOfFile: path!).data(using: .utf8)
    let session = MockURLSession(isSuccess: true, data: jsonFile)
    let networkManager = NetworkManager<WeatherRequest>(session: session)
    var outputValue: Data?
    let expectedValue = jsonFile
    // when
    networkManager.request(WeatherRequest.getCurrentWeather(latitude: 2, longitude: 2)) { result in
        switch result {
        case .success(let data):
            outputValue = data
        case .failure:
            outputValue = nil
        }
    }
    // then
    XCTAssertEqual(expectedValue, outputValue)
}

```
</div></details>

#### 3. Json 모델 타입 구축
- 오픈 API를 활용해 JSON데이터를 받아올 모델 타입을 구현

<details><summary>구현 코드</summary><div markdown="1">

```swift=
struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String?
    let main: Main
    let visibility: Int?
    let wind: Wind?
    let cloud: Cloud?
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys?
    let timezone: Int?
    let id: Int
    let name: String?
    let cod: Int?
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case cloud = "clouds"
        case weather, base, main, visibility, wind,
             rain, snow, dt, sys, timezone, id, name, cod
    }
}

```
</div></details>

### 🤔 고민했던점 및 해결
1. 모델타입 프로퍼티 옵셔널 처리 여부
    - **[문제상황]** 
    서버에서 오는 데이터를 POSTMAN을 통해 확인해보았을 때, 경우에 따라 오지 않는 데이터가 존재해 에러가 발생하였음. 
        (예를 들어, 비가 오지 않는 경우 JSON데이터에서 "rain" key가 존재하지 않음)
    - **[해결방법]**
        - JSON 데이터와 매칭할 모델 타입의 프로퍼티에 옵셔널 추가
            - API 문서를 확인해 JSON key 중에서 없을 경우 크리티컬해보이는 것들을 제외하고 모두 옵셔널 처리 해주었음
            - 논옵셔널 프로퍼티에 데이터가 오지 않았을 경우, 추가적으로 옵셔널 처리를 하도록 구현
        - 이후에는 UI에서 표현할 프로퍼티만 모델 타입에서 구현하거나, 필수로 구현해줘야 하는 프로퍼티의 경우 디폴트 값을 주는 방향으로 리팩토링해볼 수 있을 것

<details><summary>혀나블의 조언</summary><div markdown="1">

![](https://i.imgur.com/105hO87.png)
</div></details>


## STEP-2 위치정보 확인 및 날씨 API 호출

### 🍎 적용 개념
#### Core Location
- Core Location을 활용해 '현재 위치의 위도와 경도 확인' 및 '위도, 경도를 활용해 현재 주소 확인'기능 구현
<details><summary>구현 코드</summary><div markdown="1">

```swift=
class ViewController: UIViewController {
    private let networkManager = NetworkManager<WeatherRequest>()
    private let parsingManager = ParsingManager()
    private var currentWeather: CurrentWeather?
    private var fiveDayForecast: FiveDayForecast?
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringVisits()
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let latitude = visit.coordinate.latitude
        let longitude = visit.coordinate.longitude
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchFiveDayForecast(latitude: latitude, longitude: longitude)
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let address = placemarks?.first {
                print(address.administrativeArea)
                print(address.locality)
            }
        }
    }
}
```
</div></details>

#### Protocol-Oriented Approach
- 범용성, 재사용성을 고려해 네트워킹 타입을 Protocol을 활용해 Generic Type으로 구현
    - URLRequest를 구성하는 필수 요소를 담은 프로토콜인 `TargetType`과 해당 프로토콜을 채택하는 실제로 날씨 정보에 대한 Request를 구성할 `WeatherRequest` enum 타입을 구현
    - `NetworkManager`에서 `TargetType`프로토콜을 제네릭으로 받아 `WeatherRequest`이외에도 다양한 Request타입을 하나의 `NetworkManager`로 처리할 수 있도록 범용성과 재사용성을 고려해 구현

<details><summary>구현 코드</summary><div markdown="1">

```swift=
protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: (Double, Double) { get }
    
    func configure() -> URLRequest?
}
```

```swift=
class NetworkManager<T: TargetType> {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request(_ request: TargetType, completion: @escaping SessionResult) {
        guard let urlRequest = request.configure() else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { data, response, error in
```
```swift=
enum WeatherRequest: TargetType {
    case getCurrentWeather(latitude: Double, longitude: Double)
    case getFiveDayForecast(latitude: Double, longitude: Double)
    
```

</div></details>

### 🤔 고민했던 점 및 해결
1. `fetchCurrentWeather()`, `fetchFiveDayForecast()`를 하나의 메소드로 합칠것인가?
    - 첫 번째 시도: `fetchWeatherData()`라는 하나의 메소드 안에서 모델 타입 분기
        - 어떤 Json 파일로 decode를 해주어야할 지 분기를 해주어야하기에 code의 가독성이 좋지 않은 점, 다른 모델 타입이 추가되었을 때 해당 메소드의 분기를 추가해줘야하는 점 등의 문제가 여전히 존재. 
    - 두 번째 시도: `fetchWeatherData<T:Decodable>(to model: T.Type)`의 형식으로 매개변수에 모델 타입을 받아줌
        - 제네릭 타입 T와 JSON을 파싱한 모델을 할당할 타입(`CurrentWeather`, `FiveDayForedcast`타입)이 서로 맞지 않아 구현하지 못했음.

    => 위 두가지를 바탕으로 중복되는 코드가 있더라도 모델 타입에 따라 메소드를 두개로 구분을 해주었다.

2. Location services 중 어떤 service를 적용할 지에 대해 고민
    - 날씨 어플의 경우, 지속적으로 위치를 업데이트하지 않아도 되고 사용자가 날씨를 확인하는 경우에만 위치 정보를 업데이트하면 되기 때문에 가장 power-efficient한 Visits Location Service를 사용해 구현함

3. 테스트코드에서 enum case의 연관값으로 위도, 경도 값을 주었을 때 해당 값을 인식하지 못하고 시뮬레이터의 위도를 인식하는 문제 발생
    - **[문제 원인]**
        - Unit Test의 경우에도 테스트를 실행하면 시뮬레이터가 켜지면서 앱이 실행되기 때문에 ViewController로 이동하게 됨. ViewController에서 CoreLocationManagerDelegate를 구현하고 있어 Delegate메소드가 자동으로 실행되면서 시뮬레이터의 위치를 인식하게 됨.
        - `NetworkManager`의 `request()`메소드는 URLSession을 사용해 비동기로 동작하는데 네트워크와 통신하는 시간을 기다려주지 않아 통신 결과가 반영되지 않고 다음 코드로 넘어갔음.
    - **[해결방법]**
        - `XCTestExpectation()`과 `wait()`메소드를 사용해 실제 네트워크 통신 결과가 반영되도록 테스트 코드를 수정해주었음. 
