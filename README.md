# ☀️ 날씨 정보 프로젝트

- 프로젝트 기간: 2021년 9월 27일 ~ ing
- 프로젝트 진행자: Coden, Shapiro

&nbsp;    
# STEP1 - 모델 및 네트워킹 타입 구현

## 📖 학습개념

1. 오픈 API를 사용하기 위한 모델 설계
2. `CodingKeys` 프로토콜을 활용하여 실제 타입을 사용할 때 의미가 명확하도록 네이밍 변경 
3. JSONDecoder를 이용하여 Data를 파싱할 타입 설계
4. 프로토콜을 이용하여 범용성, 재사용성, 확장성을 고려한 네트워킹 타입 구현
5. URLSession을 이용하여 네트워크 작업을 하는 타입 구현

&nbsp;    
## 💫 TroubleShooting

1. API Key가 git에 올라가지 않도록 하기 위해서 별도의 파일을 만들어두고 `.gitignore`에서 이 파일이 올라가지 않도록 만들어두었다. 실무에서는 (API Key를 감추기 위해) 어떤 방식을 사용하는가?
    - 우리는 `.xcconfig` 파일을 별도로 만들어 이용하는 방식을 선택하였다.
    - `.xcconfig`가 적용될 수 있도록 Project Configurations 설정을 해주었다.

        ![https://user-images.githubusercontent.com/39452092/136565769-485bed11-9303-4fd1-a4e1-330e56e281b1.png](https://user-images.githubusercontent.com/39452092/136565769-485bed11-9303-4fd1-a4e1-330e56e281b1.png)

    - 해당 파일에 대한 내용을 `Info.plist`에서 가져오도록 이후 설정하였다.

        ![https://user-images.githubusercontent.com/39452092/136565529-ec960553-cc21-49bc-9d69-73f740516bf0.png](https://user-images.githubusercontent.com/39452092/136565529-ec960553-cc21-49bc-9d69-73f740516bf0.png)

    - 코드에서 사용할 때에는 아래의 방식을 이용하였다.

        ```swift
        private let apiKey: String = 
        		Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
        ```

    <details>
    <summary> <b> vivi의 답변 </b>  </summary>
    <div markdown="1">

    ![https://user-images.githubusercontent.com/39452092/136575005-257e0ab3-a38f-4be7-95f0-131fe82ecb13.png](https://user-images.githubusercontent.com/39452092/136575005-257e0ab3-a38f-4be7-95f0-131fe82ecb13.png)

    </div>
    </details>
&nbsp;    

2. API를 구현할 때 확장성을 많이 고려했다. "미래에는 이러 저러한 부분이 더 추가가 되지 않을까?"하고 구현을 하다 보니 지금 당장 쓰이지 않는 부분까지 코드를 만들게 되는 것 같다. 어느 부분까지 확장성을 고려해서 작성하는 것이 좋을지에 대한 의문이 들었다.
    - `APIable`에서 프로젝트에서는 사용하지 않지만 Request API를 만드는데 필요한 부분을 미리 구현해 두었다. ex) `contentType`, `parameter`

        ```swift
        protocol APIable {
            var requestType: RequestType { get }
            var url: URL? { get }
            var parameter: [String: Any]? { get }
            var contentType: ContentType? { get }
        }
        ```

    - `CallType`에서 당장은 쓰지 않을 case들까지 미리 고려해둔 부분

        ```swift
        enum CallType {
            case cityName(cityName: String, parameter: CommonWeatherAPIParameter?)
            case cityID(cityID: Int, parameter: CommonWeatherAPIParameter?)
            case geographicCoordinates(coordinate: Coordinate, parameter: CommonWeatherAPIParameter?)
            case ZIPCode(ZIPCode: Int, parameter: CommonWeatherAPIParameter?)
        }
        ```

        <details>
        <summary> <b> vivi의 답변 </b>  </summary>
        <div markdown="1">

        ![https://user-images.githubusercontent.com/57553889/136575201-d57d036a-a42f-4cac-8fc5-42e19deaddfa.png](https://user-images.githubusercontent.com/57553889/136575201-d57d036a-a42f-4cac-8fc5-42e19deaddfa.png)

        </div>
        </details>
&nbsp;    

3. `NetworkManager`의 `request`메서드에서 `URLSession`을 통해 실제 통신이 이루어진다. 이때  completionHandler를  `DispatchQueue.main.async`로 감싸줘야할지에 대해 의문이 생겼다.
    - 메서드를 사용하는 외부에서는 이 핸들러가 어떤 쓰레드에서 실행 될지 잘 모를 수 있으므로 감싸주는게 좋지 않을까?
    - 부가적인 작업(이를테면 데이터를 이미지로의 변환)이 있는 경우 이는 다른 쓰레드에서 실행되는 것이 성능 상 좋으므로 메인 쓰레드에서 실행하는 것을 보장하는 것은 메서드를 사용하는 외부(이를테면 ViewController)에서 관리해야 하지 않을까?

    두가지의 의견이 나왔는데 각각의 장단점이 있어 고민이 되었다.

    `request` 메서드는 아래와 같이 구현했다.

    ```swift
    static func request(using api: APIable,
                            completionHandler: @escaping (Result<Data, Error>) -> Void) {
            guard let url = api.url else {
                return completionHandler(.failure(NetworkError.invaildURL))
            }
            
            let urlSession = URLSession.shared
            let urlRequest = generateURLRequest(by: url, with: api)
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    return completionHandler(.failure(error))
                }
                guard let response = response as? HTTPURLResponse, successCode ~= response.statusCode else {
                    return completionHandler(.failure(NetworkError.failedResponse))
                }
                guard let data = data else {
                    return completionHandler(.failure(NetworkError.notAvailableData))
                }
                completionHandler(.success(data))
            }.resume()
        }
    ```

    <details>
    <summary> <b> vivi의 답변 </b>  </summary>
    <div markdown="1">

    ![https://user-images.githubusercontent.com/39452092/136575334-d4fa05fb-5d1c-4bad-9851-60289b82f4ae.png](https://user-images.githubusercontent.com/39452092/136575334-d4fa05fb-5d1c-4bad-9851-60289b82f4ae.png)

    </div>
    </details>
&nbsp;    

4. `DataStructure`내 모델 타입들 프로퍼티를 옵셔널로 전부 처리하였다. API문서에서 어떤 데이터가 올지 안올지 명확하게 쓰여있지 않았기에 모든 프로퍼티를 옵셔널로 만들어 둔 것이었는데 이는 적절한 조치였던 것일까?
    - 옵셔널 프로퍼티가 아닌 경우 해당 값은 반드시 들어와야 한다. 만약 해당 프로퍼티에 대한 값이 들어오지 않으면 디코딩을 했을 때 문제가 생길 수 있다.
    - 아래는 5일 예보에 대한 모델타입인 `WeatherForOneDay` 프로퍼티들이다.
    - 실제로 테스트 해봤을 때, 값이 들어올 때도 있고 안들어올 때도 있는 프로퍼티들이 많이 존재했다.

    <img src="https://user-images.githubusercontent.com/39452092/136566461-9cecfe04-9056-4924-96d5-1329e342e5af.png" width="500" />

    <details>
    <summary> <b> vivi의 답변 </b>  </summary>
    <div markdown="1">

    ![https://user-images.githubusercontent.com/57553889/136575509-6b329a19-1e4d-4f1f-981f-3e9a92a20203.png](https://user-images.githubusercontent.com/57553889/136575509-6b329a19-1e4d-4f1f-981f-3e9a92a20203.png)

    </div>
    </details>
&nbsp;    

5. API문서에 나와있는 JSON 파라미터들의 이름이 너무 알아보기 힘들어서 우리 입맛대로 `CodingKeys`를 사용하여 많이 바꿔봤는데, 이는 적절했던 것일까? (`DataStructure`내 모델 타입들 프로퍼티 명으로 적용할 때)
    - 서버 개발자와 많은 이야기를 하는 것이 얼마나 중요한 것인지 알 수 있었던 계기
    - 아래는 한 예시(사실 바꾼 것도 마음에 들지는 않는다.)

    <img src="https://user-images.githubusercontent.com/39452092/136567063-f2536566-8fe0-4fac-ad87-4de9effdbcc4.png" width="500" />

    <details>
    <summary> <b> vivi의 답변 </b>  </summary>
    <div markdown="1">

    ![https://user-images.githubusercontent.com/39452092/136575452-a4d9e544-a31f-489b-a320-21abb4bdc638.png](https://user-images.githubusercontent.com/39452092/136575452-a4d9e544-a31f-489b-a320-21abb4bdc638.png)

    </div>
    </details>
&nbsp;    

6. 옵셔널을 담을 때 `Any`에 담을 것인가 `Any?`에 담을 것인가

    ![https://user-images.githubusercontent.com/39452092/136575886-ed627839-696b-417d-a301-c594a6389bce.png](https://user-images.githubusercontent.com/39452092/136575886-ed627839-696b-417d-a301-c594a6389bce.png)

    - [Swift Language Guide - TypeCasting](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html) 맨 밑을 보면 Any에도 Optional을 담을 수 있다.
    - [RxSwift - CLLocationManager+Rx.swift](https://github.com/ReactiveX/RxSwift/blob/main/RxExample/Extensions/CLLocationManager+Rx.swift)를 보면 `Any`에 담긴 `nil`을 판단할 때 `NSNull`을 사용하고 있다.
    - `Any`타입의 프로퍼티에 `nil`을 직접적으로 담을 수는 없지만, `nil`을 가진 옵셔널 타입 인스턴스를 담을 수는 있다.

    ➡️ vivi의 답변

    `Any`타입으로 타입캐스팅을 하여 `nil`이 담긴 변수를 이용할 수는 있지만, 그렇게 하기보다 `Any?`로 명시적 사용을 해주는 것이 좋을 것 같다. (사용하는 입장에서 nil이 담겨있을 수도 있다는 것을 알 수 있으므로)
    
&nbsp;    

# STEP2- 사용자 위치정보를 획득하고 이를 이용하여 날씨정보 얻어오기

## 📖 학습개념

1. `Info.plist`에 (위치 서비스 관련) 기기 제한사항 추가 및 위치 권한 관련 메시지 설정
2. CoreLocation을 이용하여 사용자 위치 권한 획득 및 위치 이벤트 수신하기
3. 앱에 가장 적절한 위치 서비스를 선택하고 적용하기(`startMonitoringSignificantLocationChanges`)
4. CoreLocation을 이용한 reverseGeocoding
5. `DispatchGroup`을 이용하여 여러 비동기 작업들 그룹화 및 `notify`를 이용한 후속처리
6. `DispatchWorkItem`을 이용하여 작업 추적 및 취소 구현
7. `Equatable`을 이용하여 비교 연산자 커스텀 구현

&nbsp;    

## 💫 TroubleShooting

***가장 큰 문제는 3개의 데이터(현재날씨, 5일날씨, 주소)를 개별적으로 따로 가져와야 함에서 비롯되었다.***

1. 3개 데이터(현재날씨, 5일날씨, 주소) 의 업데이트 동기화 문제
    - `DispatchGroup`을 이용하여 해결했다.
    - 현재날씨, 5일날씨, 주소 3개의 데이터가 전부 비동기 작업을 통해 데이터를 얻어내기 때문에 이 작업들을 `DispatchGroup` 으로 묶어 모든 작업들이 끝난 것을 보장한 후 UI 업데이트를 하도록 구현했다.

    ```swift
    private func prepareWeatherInformation(with location: CLLocation, completionHandler: @escaping (String?, WeatherForOneDay?, FiveDayWeatherForecast?) -> Void) {
          //...
          prepareInformationDispatchGroup.enter()
          AddressManager.generateAddress(from: location) { 
    					//주소값을 얻어오는 로직
              prepareInformationDispatchGroup.leave()
          }
          
          prepareInformationDispatchGroup.enter()
          NetworkManager.request(using: weatherForOneDayAPI) { 
    					//현재 날씨를 얻어오는 로직
              prepareInformationDispatchGroup.leave()
          }
          
          prepareInformationDispatchGroup.enter()
          NetworkManager.request(using: fivedayWeatherForecastAPI) {
    					//5일 예보를 얻어오는 로직
              prepareInformationDispatchGroup.leave()
          }
          
          prepareInformationDispatchGroup.notify(queue: .main) {
              //받아온 데이터들을 이용하여 UI 업데이트에 대한 completionHandler 호출
          }
      }	
    ```
&nbsp;    

2. 새로운 데이터를 받아왔을때 변동이 없음에도 모델을 업데이트 할것인가?
    - 데이터에 실질적인 변화가 없음에도 모델 및 UI를 업데이트 하는 것은 낭비라고 생각하였다.
    - 각각의 모델에 `Equatable` 프로토콜을 채택시켜 실질적인 데이터 변화가 있는지 확인 후 업데이트 하도록 구현하였다. (그리고 변화가 있는 경우, 해당 데이터에 대해서만 UI 업데이트가 일어나도록 처리하였다.)

    ```swift
    struct SomeModel: Decodable, Equatable {
    		static func == (lhs: WeatherForOneDay, rhs: WeatherForOneDay) -> Bool {
            //데이터의 ID값과 데이터 산출시간 등을 비교하여 값에 실질적인 변화가 발생했는지 체크
        }
    }

    //UI 업데이트를 하는 클로저 내부
    if self?.userAddress != userAddress {
    		self?.userAddress = userAddress
        self?.updateUserAddressLabel()
    }
    if self?.weatherForOneDay != weatherForOneDay {
        self?.weatherForOneDay = weatherForOneDay
        self?.updateHeadView()
    }
    if self?.fiveDayWeatherForecast != weatherForFiveDay {
        self?.fiveDayWeatherForecast = weatherForFiveDay
        self?.updateTableView()
    }
    ```
&nbsp;    

3. UI를 그리는 도중에 모델에 변동이 있으면 어떻게 해결할 것인가? (`race condition`)
    - 우리 코드에서 발생했던 문제가 모델을 변동하는 작업은 비동기적으로 백그라운드 쓰레드에서 이루어지고 UI를 그리는 작업은 전역 변수로 선언된 프로퍼티에 접근을 하기 때문에 발생했다.
    - `notify(queue: .main)` 및 completionHandler를 이용하여 모델 인스턴스에 대한 읽기 쓰기 작업은 main 쓰레드에서만 하도록 변경했다.

    ```swift
    // DispatchGroup들의 작업이 끝난 후 notify를 통한 클로저 내부
    prepareInformationDispatchGroup.notify(queue: .main) {
    	guard let updateWorkItem = self.updateWorkItem,
            updateWorkItem.isCancelled == false else {
    		return
    		}
    	completionHandler(userAddress, weatherForOneDay, weatherForFiveDay)
    ```

    - 위의 코드를 통해 3가지 정보를 전부 다 받아온 후에 main 쓰레드에서 프로퍼티를 업데이트하고 UI를 그리도록 구현했다.

&nbsp;    

4. UI 업데이트가 중첩될 수 있는 문제
    - 사용자의 위치가 빠르게 변하는 경우(이를테면 KTX를 탔다던가), UI업데이트에 대한 `DispatchGroup.notify(queue: main) { //... }` 작업이 메인 큐에 지나치게 많이 쌓일 수 있다고 판단하였다.
    - 이는 `DispatchWorkItem`을 이용하여, 작업이 중복되어 실행되는 경우 이전의 작업은 취소 되도록 구현하였다.
    - 다만 실제로 이전 작업이 취소되는 것은 아니므로 후속 작업(UI업데이트)을 하기 전, 작업이 이미 취소되었는지를 검증하는 로직을 만들어두었다.

    ```swift
    //프로퍼티
    private var updateWorkItem: DispatchWorkItem?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    		//...		
        
        updateWorkItem?.cancel()
        updateWorkItem = nil
        
        updateWorkItem = DispatchWorkItem(block: { 
    				//UI 업데이트 로직
        })
        if let updateWorkItem = updateWorkItem {
            DispatchQueue.main.async(execute: updateWorkItem)
        }
    }

    //모든 데이터 가져오기 작업이 완료된 후 UI를 업데이트 하기 전에 해당 작업이 취소되었는지 체크
    DispatchGroup.notify(queue: .main) {
        guard let updateWorkItem = self.updateWorkItem,
              updateWorkItem.isCancelled == false else {
            return
        }
        completionHandler(userAddress, weatherForOneDay, weatherForFiveDay)
    }
    ```
&nbsp;    

5. 타입을 extenstion으로 분리 시킬때 메서드의 위치를 어떻게 할것인가?
    - 우리는 UI작업, Load Information, Conforms to CLLocationManagerDelegate, 프로퍼티와 Lifecycle본체로 ViewController를 나누었다.
    - 기능, 접근 제어자, 서로 호출되는 연관성 등등... 을 기준으로 나누어 볼 수 있을것 같다는 생각이 들었는데 어떠한 기준으로 메서드를 분리시키면 좋을지 의문이 들었다.
    - 다만 어떤 extension이든 간에 **공용 인터페이스**적인 메서드들은 상단에 위치시키는 것이 가독성 측면에서 좋다고 한다!
