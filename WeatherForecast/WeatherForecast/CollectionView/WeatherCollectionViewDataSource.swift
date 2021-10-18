//
//  WeatherCollectionViewDataSource.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

class WeatherCollectionViewDataSource: NSObject {
    
}

extension WeatherCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
