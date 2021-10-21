//
//  extension + UIImage.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/15.
//

import UIKit

extension UIImageView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func loadImage(from url: URL) {
        let urlString = url.absoluteString
        let cacheKey = urlString as NSString
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        DispatchQueue.global(qos: .background).async {
            if let imageURL = URL(string: urlString) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    self.errorCheck(data, response, error) { result in
                        switch result {
                        case .success(let data):
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.image = image
                                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                }
                                
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func errorCheck(_ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(APIError.unknown))
            return
        }
        print((response as! HTTPURLResponse).statusCode)
        guard (200...299).contains(response.statusCode) else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        guard let data = data else {
            completion(.failure(APIError.emptyData))
            return
        }
        completion(.success(data))
    }
}
