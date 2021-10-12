//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ())
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    
    func request(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ()) {
        let request = self.buildRequest(from: route)
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            switch response.statusCode {
            case 200..<300: break
            case 400:
                print("잘못된 요청입니다.")
                return
            case 401:
                print("인증이 잘못되었습니다.")
                return
            case 403:
                print("해당 정보에 접근할 수 없습니다. ")
                return
            case 500...:
                print("서버에러")
                return
            default:
                return
            }
            
        })
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            do {
                try URLManager.configure(urlRequest: &request, with: urlParameter)
            } catch {
                print(error)
            }
        }
        
        return request
    }
}
