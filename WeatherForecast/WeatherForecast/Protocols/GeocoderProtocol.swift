//
//  GeocoderProtocol.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/14.
//

import Foundation
import CoreLocation

protocol GeocoderProtocol {
    func reverseGeocodeLocation(
        _ location: CLLocation,
        preferredLocale locale: Locale?,
        completionHandler: @escaping CLGeocodeCompletionHandler
    )
}

extension CLGeocoder: GeocoderProtocol {}
