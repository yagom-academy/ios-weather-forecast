//
//  UIImageViewExtension.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/24.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(_ link: String) {
        guard let url = URL(string: link) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
