//
//  GeocoderManagible.swift
//  WeatherForecast
//
//  Created by YongHoon JJo on 2021/10/22.
//

import CoreLocation

protocol GeocoderManagible: AnyObject {
    func updateCoordiante(coordinate: CLLocationCoordinate2D)
}
