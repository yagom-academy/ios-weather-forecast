//
//  WeatherCollectionViewDataSource.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/10/18.
//

import UIKit

class WeatherCollectionViewDataSource: NSObject {
    private let compositionalLayout = CompositionalLayout()
    var currentWeather: CurrentWeather?
    var fiveDaysWeather: FiveDaysWeather?
    var currentAddress: String?
}

extension WeatherCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: CurrentWeatherHeaderView.identifier,
                    for: indexPath) as? CurrentWeatherHeaderView else {
                        return UICollectionReusableView()
                    }
        
        header.configure(weather: currentWeather, address: currentAddress)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return fiveDaysWeather?.list?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FiveDaysWeatherCell.identifier,
            for: indexPath) as? FiveDaysWeatherCell else {
                return UICollectionViewCell()
            }
        
        let fiveDayList = fiveDaysWeather?.list?[indexPath.item]
        cell.configure(list: fiveDayList)
        return cell
    }
    
    func decidedLayout(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout =
        compositionalLayout.create(contents: WeatherImpormationLayout())
    }
}
