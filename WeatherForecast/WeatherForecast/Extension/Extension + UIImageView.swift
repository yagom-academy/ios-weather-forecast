//
//  Extension + UIImageView.swift
//  WeatherForecast
//
//  Created by 박태현 on 2021/10/13.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: String) {
        guard let url = URL(string: url) else { return }
        let cacheKey = url.lastPathComponent as NSString
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self.image = image
                    }
                }
            }.resume()
        }
    }
}
