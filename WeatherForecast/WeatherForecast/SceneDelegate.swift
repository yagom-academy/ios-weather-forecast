//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let mainScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: mainScene)

        let locationManager = CLLocationManager(desiredAccuracy: kCLLocationAccuracyThreeKilometers)
        let locationService = LocationService(locationManager: locationManager)
        let weatherDataViewModel = WeatherDataViewModel(locationService: locationService)
        let mainViewController = MainWeatherTableViewController(weatherDataViewModel: weatherDataViewModel)
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
