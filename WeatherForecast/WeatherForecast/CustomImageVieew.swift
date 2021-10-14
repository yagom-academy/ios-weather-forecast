//
//  CustomImageVieew.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/15.
//

import UIKit

final class CustomImageVieew: UIImageView {
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let loadedImage = UIImage(data: data) else {
                      return
                  }
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
        task.resume()
    }
}
