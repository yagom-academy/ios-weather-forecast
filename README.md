# ☀️ 날씨 정보 프로젝트

- 프로젝트 기간: 2021년 9월 27일 ~ 10월 22일
- 프로젝트 진행자: Coden, Shapiro

&nbsp;
<details>
<summary> <b> 실행화면 1 - 영어 </b>  </summary>
<div markdown="1">
<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/138457234-253c5b5a-7d4c-4c73-bfd0-04d946469e6f.gif">
</div>
</details>
<details>
<summary> <b> 실행화면 2 - 한글 </b>  </summary>
<div markdown="1">
<img width="500" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/138457236-72d04591-623d-4ea7-b8ff-626fe5051439.gif">
</div>
</details>

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



<details> <summary> <b> vivi의 총평 </b>  </summary> <div markdown="1">

<img width="800" alt="스크린샷 2021-10-22 오후 8 39 37" src="https://user-images.githubusercontent.com/39452092/138447658-d129432f-85fa-45ea-8fed-66439a75942f.png"> </div> </details>

&nbsp;   

# STEP3 - UI 구현

## 📖  학습개념

1. `SectionHeaderView`가 아닌 `TableViewHeaderView` 사용
2. 코드로만 커스텀 `TableViewCell` 구현
3. `TableView`와 `UIRefreshControl`의 이용
4. `TableViewCell`에 들어가는 이미지들의 지연로딩 문제 해결
5. `DateFormatter`를 이용한 날짜 표현

&nbsp;

## 💫 TroubleShooting

1. `MainWeatherViewController`에서 `MainWeatherTableViewCell`에 데이터를 설정해주는 방식에 대하여

DataSource에서 데이터를 셀에 세팅해줄 때 어떠한 방식으로 세팅시켜주는 것이 가장 적절할까? 우리는 아래와 같은 3가지 방식들을 생각해 보았다.

1. 위처럼 구체적인 Model타입을 셀에 넘겨주고 셀 내부에서 필요한 데이터를 뽑아 알아서 세팅하도록 하는 방법

   - View가 Model을 직접적으로 아는 것은 부적절하다는 의견이 있음(MVC 위배)

2. 뷰 컨트롤러에서 개별적으로 데이터를 넘겨주는 방법(String이나 ImangeView를 메서드 파라미터로 일일히 넘기는 방법)

   - 또는 DataSource에서 셀의 개별 프로퍼티에 직접 접근하여 바로 설정하는 방법
   - 셀에 대한 것은 셀에서 하는 것이 맞지 않은가 하는 의견이 있음

3. 데이터를 가지고 있음을 기대할 수 있는 어떤 프로토콜을 만들어두고 이를 이용하는 방법(의존성 역전)

   - 해당 프로토콜을 준수하는 구체적인 하위 타입을 정해야함

   &nbsp;

```swift
//MainWeatherTableViewCell.swift
func configure(data: WeatherForOneDay) {

}
```

- 우리는 일단 Cell에 대한 설정방식과 `MainWeatherViewController`에서 `MainWeatherHeaderView`에 데이터를 설정해주는 방식도 위의 1번 방식을 사용하도록 설정해 두었다.

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="800" alt="비비의 답변" src="https://user-images.githubusercontent.com/39452092/138446127-a0130e4a-26c6-4438-ae33-12731ce90eac.png"> </div> </details>

&nbsp;

2. `UITableView`의 `HeaderView`에 대하여.
   * `UITableView`의 `HeaderView`의 높이를 지정해줘야 하는 부분에서 문제가 발생했다.
   * 동적으로 높이가 알아서 설정되도록 할 수는 없을까? (기기별로 알아서 조절된다던지 하도록)
   * 구글에서 찾아봤을 때, 다른 사람들은 `layoutIfNeeded()`를 써주던것을 보았는데 우리 코드에서 반드시 필요한 부분은 아니라는 생각이 들었다.
   * 우리는 아래와 같은 방법으로 `HeaderView` 높이를 구하였다.

```swift
private func sizeHeaderViewHeightToFit() {
    guard let headerView = tableView.tableHeaderView else {
        return
    }
    let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    var frame = headerView.frame
    frame.size.height = height
    headerView.frame = frame
}
//headerView에 컨텐츠가 들어갔을 때마다(address, 온도별로 따로) 매번 호출되도록 하고 있음
```

- 뷰가 가질 수 있는 가장 작은 크기를 얻어와서 뷰의 최적 크기를 계산하는데 사용하였다. 
- 우리가 내린 결론은 **"커스텀 헤더 뷰 내에서 스스로의 크기를 아는 것은 소용이 없고, 외부에서 직접 테이블 뷰의 헤더뷰 크기를 지정해주어야 하는 것 같다."** 이다.

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="800" alt="스크린샷 2021-10-22 오후 8 28 12" src="https://user-images.githubusercontent.com/39452092/138446306-2172f9bf-1ade-4c7d-8a85-02b561a96cfe.png"> </div> </details>

&nbsp;

3. 날짜 요구사항에 맞게 `Date`를 표현하는 방법에 대하여

   * `DateFormatter.dateFormat` 설정으로 하는 방법을 찾지 못했다.
   * `setLocalizedDateFormatFromTemplate`을 이용해서 별 짓을 다 해봤는데, `월/일(요일) 시간` 형식으로 출력 하려면 어떤 템플릿을 써야하는지 찾지 못했다.
   * 가장 큰 문제는 `locale`을 `.current`로 설정 했는데, 기기 언어 및 지역을 한국으로 했음에도 날짜 표기가 변하지가 않았다.

   

   현업에서 지역화를 할때 `Locale.preferredLanguages` 를 사용한다는 말을 듣고 아래와 같이 구현하여 `locale`을 `.current`로 설정 했음에도 표기가 변하지 않는 문제를 해결했다.

```swift
//날짜를 명세에 맞게 변화해주는 로직 일부
dateFormatter.locale = Locale(identifier: preferredLanguage)
dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdEHH")
```

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="800" src="https://user-images.githubusercontent.com/39452092/138446538-465f51d2-b813-4733-aa05-8a192525bd14.png" />

<img width="800" src="https://user-images.githubusercontent.com/39452092/138446589-bd6b170f-3017-485c-a4a7-16148b2aa100.png" /> </div> </details>

&nbsp;

4. HeaderView의 AutoLayout이 왜 터지는지 모르겠다.
   * 이 문제는 해결을 하지 못했지만 그림을 그려보면서 레이아웃이 모호한 부분이 없는지 다 확인을 하는 작업을 거쳤었다.
   * 화면이 작은 기기와 큰 기기 모두 테스트를 해봤을때 그려지는 결과물은 전부 정상적으로 나왔다.
   * 우리가 내린 결론은 **"헤더뷰의 contents 들이 정해지지 않았을때 오류가 발생했고, contents들이 채워지면서 AutoLayout이 정상적으로 작동 한것이 아닐까?"** 이다.

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="800" alt="스크린샷 2021-10-22 오후 8 29 29" src="https://user-images.githubusercontent.com/39452092/138446458-b5a1a132-5f04-40cf-ae46-444d78d03a52.png"> </div> </details>

&nbsp;

# STEP4 - 수동 위치 설정 기능 추가

## 📖  학습개념

1. `UIAlertController`에 TextField를 만들어 사용자 입력을 받기
2. 사용자가 위경도를 입력하는 것에 대응하기 위한, 동적인 매개변수(parameter) 대응 네트워킹 타입 구현

&nbsp;

## 💫 TroubleShooting

1. ViewController에서 Alert을 띄웠을때 AlertAction의 클로저와 순환 참조 발생 문제

   - `MainWeatherViewController` 에서 `UIAlertController`를 이용하여 Alert을 띄울때 순환 참조 문제가 발생했다.

   - 우리는 `UIAlertController`에서 TextField를 이용해 사용자에게 값을 받아왔는데, `UIAlertAction`의 completion closure가 TextField를 참조하기 위해 Alert를 capture하고 있었다.

   - `MainWeatherViewController`와 `UIAlertController`도 서로 강한 참조를 하고 있지만 dismiss가 되면서 서로의 관계가 끊긴다는 것을 확인했다.

   - 최종적으로 `UIAlertController` → `UIAelrtAtion` → completion closure → `UIAlertController`  순환 참조가 발생하고 있다는 사실을 알게되었다.

   - 순환참조에 의해 `UIAlertController`가 사라지지 않는다는 것은 `UIAlertController`를 상속받은 커스텀 클래스를 만들어 테스트 함으로써 확인하였다.

     ```swift
     class CustomAlertController: UIAlertController {
        deinit {
            print("deinit log --- 인스턴스 해제")
        }
     }
     ```

   아래는 우리가 예상한 인스턴스간의 참조를 나타낸 그림이다.

   ![https://user-images.githubusercontent.com/57553889/137527136-cfd7f012-411c-4bdf-9bd9-ec54d3da00fe.png](https://user-images.githubusercontent.com/57553889/137527136-cfd7f012-411c-4bdf-9bd9-ec54d3da00fe.png)

   &nbsp;

   - `UIAlertAction`의 completion closure에서 `UIAlertController`를 약한참조 함으로써 해결하였다.
   - `UIViewController`에 대한 약한 참조는 반드시 필요한 것은 아니지만 안전을 위해 추가해두었다.

```swift
let changeAction = UIAlertAction(title: "ChangeLocationAlert_ChangeAction_Title".localized(), 
                                 style: .default) { [weak self, weak alert] _ in
    guard let self = self, let alert = alert else {
        return
    }
    if let latitudeText = alert.textFields?.first?.text, let longitudeText = alert.textFields?.last?.text,
       let latitude = Double(latitudeText), let longitude = Double(longitudeText) {
        let desiredLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.locationManager(self.locationManager, didUpdateLocations: [desiredLocation])
    }
}
```

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="807" alt="스크린샷 2021-10-22 오후 8 53 23" src="https://user-images.githubusercontent.com/39452092/138449203-2532e0d7-84c5-4653-bece-9ed71cb247cd.png"> </div> </details>

&nbsp;

# STEP5 - 지역화 및 화면회전

## 📖  학습개념

1. 지역화 기능 구현

   &nbsp;

## 💫 TroubleShooting

1. API 요청 시 `CommonWeatherAPIParameter` 타입 내의 `LanguageType` 프로퍼티 사용 여부
   - API를 요청할 때 `LanguageType`을 통해 지역화를 관리 및 구현해보려했다. 하지만 `LanguageType`을 지정하여 파라미터로 보낸다고 해도 response의 내용들은 딱히 바뀌지 않는 것을 발견했다.
   - 우리는 API에 의존하기 보단 로컬에서 지역화를 하는 방법을 택했다.

<details> <summary> <b> vivi의 답변 </b>  </summary> <div markdown="1">

<img width="672" alt="스크린샷 2021-10-22 오후 9 25 11" src="https://user-images.githubusercontent.com/39452092/138453210-c52a8230-f626-4258-8c18-44d81d9a78d1.png">
</div>
</details>

&nbsp;

2. Localizing과 관련한 비비의 의견

<img width="796" alt="스크린샷 2021-10-22 오후 9 27 46" src="https://user-images.githubusercontent.com/39452092/138453538-44eb1dc7-14d2-4385-a96f-26454a033386.png">

* 생각을 해보니, 우리가 보아도 위의 방식은 다소 헷갈릴 여지가 많다고 느꼈다. 따라서 아래와 같이 수정하였다. 

```swift
//TableView HeaderView
"HeaderView_HighestTemperatureLabel_Text" = "최고 ";
"HeaderView_LowestTemperatureLabel_Text" = "최저 ";
"HeaderView_LocationSettingButton_Title" = "위치 변경";

//Change Location Alert
"ChangeLocationAlert_Title" = "위치 변경";
"ChangeLocationAlert_Message" = "변경할 좌표를 입력해주세요";
"ChangeLocationAlert_LatitudeTextField_Placeholder" = "위도";
"ChangeLocationAlert_LongitudeTextField_Placeholder" = "경도";
"ChangeLocationAlert_ChangeAction_Title" = "변경";
"ChangeLocationAlert_SetCurrentLocationAction_Title" = "현재 위치로 재설정";
"ChangeLocationAlert_CancelAction_Title" = "취소";

```

&nbsp;

3-1. 위치정보에 대한 문제 발견

실 기기에서 테스트를 해봤는데 앱 최초 실행 시 주소정보가 올바르게 표기되지 않는 문제가 발견되었다. `UIRefreshControl`을 이용하여 새로고침을 하면 주소정보가 받아와진다는 점에서 우리가 작성한 로직이 문제가 있는 것인지 디버깅을 해보았다.

<details> <summary> <b> 문제 화면 </b>  </summary> <div markdown="1">

<img width="807" alt="스크린샷 2021-10-22 오후 8 53 23" src="https://user-images.githubusercontent.com/39452092/138450572-647ba207-463c-4648-b1d8-2d63f32975ed.png">

</div> </details>

&nbsp;

- 최초 실행 시 좌표값과 주소값에 대한 정보는 아래와 같았다.

<img width="900" src="https://user-images.githubusercontent.com/39452092/138454159-b518e35f-b824-4dd1-a747-a14c7a93a979.png" />

&nbsp;

- RefreshControl을 이용하여 새로고침을 했을 시 받아와진 정보는 아래와 같았다.

<img width="900" src="https://user-images.githubusercontent.com/39452092/138454168-8557acda-c3a2-4712-9ae7-14fddd34f99d.png" />

&nbsp;

```swift
guard let adminstrativeArea = address.administrativeArea, 
			let locality = address.locality, 
			let thoroughfare = address.thoroughfare else {
    return completionHandler(.failure(AddressTranslationError.invalidAddress))
}
let userAddress = "\\(adminstrativeArea) \\(locality) \\(thoroughfare)"
```

- 앱 최초 실행시에는 부정확한 위치정보로 요청이 request되는데 이 때 `address.thoroughfare`가 `nil`이 들어왔기 때문에 주소 설정이 올바르게 동작하지 않았다.
- 새로고침을 했을 때에는 위치정보의 오차반경이 줄어들어 정확도가 높아졌고 `address.thoroughfare`가 넘어오게 되면서 주소 설정이 올바르게 동작했다.
- 따라서 해당 로직을 아래와 같이 수정해주었다.

```swift
guard let adminstrativeArea = address.administrativeArea,
		  let locality = address.locality else {
    return completionHandler(.failure(AddressTranslationError.invalidAddress))
}
let thoroughfare = address.thoroughfare
let userAddress = "\\(adminstrativeArea) \\(locality) \\(thoroughfare ?? "")"
```

<details> <summary> <b> 수정 이후 </b>  </summary> <div markdown="1">

<img width="807" alt="스크린샷 2021-10-22 오후 8 53 23" src="https://user-images.githubusercontent.com/39452092/138450413-ae9923dc-e9e2-457c-a258-5bc9969cee33.png">

최초 로딩 시에도 주소정보가 잘 나온다. 

</div> </details>

&nbsp;

3-2. 위치 정보 수정시 발생했던 문제

- 위의 수정을 진행하였으나 예측하지 못한 추가 문제를 발견하였다.

  - 처음에는 다소 부정확한 위치정보가 받아와지고 새로고침을 하는 경우 더 정확한 위치정보가 받아와졌다.


&nbsp;   

  <details> <summary> <b> 최초 로딩 시 </b>  </summary> <div markdown="1">

  <img width="807" alt="스크린샷 2021-10-22 오후 8 53 23" src="https://user-images.githubusercontent.com/39452092/138450006-d7d40d60-8d36-4c08-b536-4ef7186c32a7.png"> </div> </details>

  <details> <summary> <b> 새로고침 이후 </b>  </summary> <div markdown="1">

  <img width="807" alt="스크린샷 2021-10-22 오후 8 53 23" src="https://user-images.githubusercontent.com/39452092/138450071-9317b876-e3af-4268-9f29-a5f2c06a9a0e.png"> </div> </details>

  &nbsp;

- 하지만 처음부터 위치가 정확하게 받아와지는 것이 사용자 입장에서 더 자연스러울 것 같다는 이야기가 있었다.

- 더군다나 현재 우리의 코드는 `CLLocationManager`의`startMonitoringSignificantLocationChanges()`를 켜둔 상태에서 필요할 때마다 `requestLocation()`을 추가적으로 호출하는 방식이다.

  - `requestLocation()`이 내부적으로는 `startUpdatingLocation()`과 `stopUpdatingLocation()`을 하는 방식이다보니 기존에 켜져 있던 `startMonitoringSignificantLocationChanges()`과 상호 영향이 있을 수도 있다고 판단하였다.
  - 실제로 테스트해본 결과 `startMonitoringSignificantLocationChanges()` 또는 `startUpdatingLocation()`을 켜둔 상태에서 `requestLocation()`의 요청이 적절한 시간에 완료되지 않는 문제가 발견되었었다. (이유는 잘 모르겠으나 locationManager-didUpdateLocations가 간혹 굉장히 늦게 호출되었었다.)
  - 이 외에도 `desiredAccuracy`에 따라 로딩시간의 차이가 많이 발생하였는데 이에 대한 원인은 밝혀내지 못했다.

- 따라서 최초 앱 로딩시 및 사용자가 RefreshControl 사용 시 `requestLocation()`이 호출되도록 하였으며 `requestLocation()`이 호출될 때에는 기존의 위치 서비스가 잠시 정지되도록 설정해주었다. 이후 `requestLocation()`에 의한 작업이 모두 끝난 뒤에는 다시 위치서비스가 시작되도록 설정하였다.

- 다만 `requestLocation()`의 최초 호출 시점은 권한 허용 이후 시점으로 만들어두었다.

  - `requestLocation()`을 했는데 사용자 권한이 계속 허가가 안되어있으면 `locationManager(_:didFailWithError:)`가 호출되기 때문.

  &nbsp;

- **우리는 사용자의 입장에서 받아오는 위치의 변화가 가장 적은 방법을 택하여 구현했다.**

  - 최초 실행시 권한을 받아왔을때 `requestLocation()` 을 통해 위치 받아오기
  - 수동으로 위치를 바꾸거나, 새로고침을 했을때 위치 추적기능을 잠깐 끄고 해당 로직이 끝나면 다시 키는 로직 추가

```swift
//MARK:- Conforms to CLLocationManagerDelegate
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
```

&nbsp;

4. 셀 날짜 시간 매칭 수정 필요
   * 원래 API에서 받아온 data 중에서 `timeOfDataForecasted`라는 프로퍼티를 사용하여 셀의 시간을 받아왔다. 날씨가 예보된 시간을 사용하고 있어서 잘못된 시간 정보를 사용하고 있었다.
   * `timeOfDataCalculation` 을 사용하여 셀에서 시간을 제대로 표기할 수 있도록 수정

우리는 아래와 같이 수정했다.

```swift
// 셀에서 데이터를 받아와 날짜를 표시해주는 로직
if let forecastedDate = data.timeOfDataCalculation, let preferredLanguage = Locale.preferredLanguages.first {
      let date = Date(timeIntervalSince1970: forecastedDate)
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: preferredLanguage)
      dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdEHH")
      dateLabel.text = dateFormatter.string(from: date)
  }
```

&nbsp;

5. 실 기기에서 AlertController의 CollectionView관련 에러
   * AlertController를 띄울 때마다 발생하였는데 이 문제는 왜 발생하는 것인지 잘 모르겠다.
   * 우리는 CollectionView를 직접적으로 사용하는 부분이 없다.
   * 이에 대해 alert 및 alert의 textFields들에 대한 `translateAutoResizingMaskIntoConstraint` 설정을 true로 했다가 false로도 해봤지만 소용이 없었다. (오히려 alert가 기괴하게 변하였음)

**2021-10-22 18:08:34.439513+0900 WeatherForecast[3447:1559084] [LayoutConstraints] Changing the translatesAutoresizingMaskIntoConstraints property of a UICollectionViewCell that is managed by a UICollectionView is not supported, and will result in incorrect self-sizing. View: <_UIAlertControllerTextFieldViewCollectionCell: 0x104a60460; frame = (0 0; 270 24); gestureRecognizers = <NSArray: 0x28148b030>; layer = <CALayer: 0x281a43f00>>**

**2021-10-22 18:08:34.440665+0900 WeatherForecast[3447:1559084] Writing analzed variants.**

**2021-10-22 18:08:34.442111+0900 WeatherForecast[3447:1559084] [LayoutConstraints] Changing the translatesAutoresizingMaskIntoConstraints property of a UICollectionViewCell that is managed by a UICollectionView is not supported, and will result in incorrect self-sizing. View: <_UIAlertControllerTextFieldViewCollectionCell: 0x104b341d0; frame = (0 24; 270 24); gestureRecognizers = <NSArray: 0x28149a040>; layer = <CALayer: 0x281a507c0>>**

**2021-10-22 18:08:34.443500+0900 WeatherForecast[3447:1559084] [UICollectionViewRecursion] cv == 0x106011e00 Disabling recursion trigger logging**

**2021-10-22 18:08:34.447389+0900 WeatherForecast[3447:1559084] Writing analzed variants.**

**2021-10-22 18:08:34.504177+0900 WeatherForecast[3447:1559084] Can't find keyplane that supports type 8 for keyboard iPhone-PortraitChoco-DecimalPad; using 27100_PortraitChoco_iPhone-Simple-Pad_Default**
