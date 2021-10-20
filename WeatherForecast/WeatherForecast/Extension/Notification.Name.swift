//
//  Notification.Name.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import Foundation.NSNotification

extension Notification.Name {
    static let reloadTableView = Notification.Name("reload TableView")
    static let stopRefresh = Notification.Name("stopRefresh")
    static let requestLocationAgain = Notification.Name("reloadView")
    static let showValidLocationAlert = Notification.Name("showAlert")
    static let showInValidLocationAlert = Notification.Name("showInvalidAlert")
    static let cleanTalbeView = Notification.Name("deleteTableViewCell")
}
