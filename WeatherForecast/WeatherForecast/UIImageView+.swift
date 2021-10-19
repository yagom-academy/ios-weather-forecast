//
//  UIImageView+.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/10/19.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        var task: URLSessionDataTask?
        
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
        
        if let task = task {
            task.resume()
        }
    }
}
