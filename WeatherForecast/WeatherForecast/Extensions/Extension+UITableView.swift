//
//  Extension+UITableView.swift
//  WeatherForecast
//
//  Created by Yongwoo Marco on 2021/10/15.
//

import UIKit.UITableView

extension UITableView {
    func initRefresh(targetView: NSObject, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(targetView, action: action, for: .valueChanged)
        refreshControl.tintColor = .orange
        
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
    }
}
