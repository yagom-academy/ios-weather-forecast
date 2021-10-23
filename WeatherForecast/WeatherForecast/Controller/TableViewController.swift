//
//  TableViewController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit
import CoreLocation

func requestWeatherData(requestPurpose: RequestPurpose, location: Location?) {
    let sessionDelegate = OpenWeatherSessionDelegate()
    let networkManager = WeatherNetworkManager()
    
    networkManager
        .fetchOpenWeatherData(latitudeAndLongitude: location,
                              requestPurpose: .currentWeather,
                              sessionDelegate.session)
    
    networkManager
        .fetchOpenWeatherData(latitudeAndLongitude: location,
                              requestPurpose: .forecast,
                              sessionDelegate.session)
}

final class TableViewController: UIViewController, ButtonDelegate {
  
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let tableViewDelegate = WeatherTableViewDelegate()
    private let emptyDataSource = EmptyDataSource()
    private let emptyDelegate = EmptyDelegate()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        setRefreshControl()
        self.tableView.dataSource = self.tableViewDataSource
        self.tableView.delegate = tableViewDelegate
        setButtonDelegate()

        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(reloadTableView),
                         name: .reloadTableView,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(stopRefesh),
                         name: .stopRefresh,
                         object: nil)
    }

    func cleanTableView() {
        self.tableView.dataSource = emptyDataSource
        self.tableView.delegate = emptyDelegate
    }

    private func setButtonDelegate() {
        let firstSectionHeaderNumber = 0
        guard let headerView = self.tableView.headerView(forSection: firstSectionHeaderNumber) as? OpenWeatherHeaderView else {
            return
        }
        
        headerView.buttonDelegate = self
    }
    
    func notifyValidLocationAlert() {
        showDetailViewController(validLocationAlert, sender: nil)
        print("성공")
    }
    
    func notifyInvalidLocationAlert() {
        showDetailViewController(inValidLocationAlert, sender: nil)
    }
    
    private lazy var validLocationAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치변경",
                                      message: "변경할 좌표를 선택해 주세요",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "현재 위치로 재설정", style: .default) { _ in
            NotificationCenter
                .default
                .post(name: .requestLocationAgain,
                      object: nil)
            alert.dismiss(animated: true) {
                print("alert dismiss")
            }
        })
        
        alert.addAction(UIAlertAction(title: "변경",
                                      style: .default) {[weak self] _ in
            guard let `self` = self else { return }
            switch self.convertToValidLocation(alert.textFields) {
            case .failure(let error):
                self.tableView.delegate = self.emptyDelegate
                self.tableView.dataSource = self.emptyDataSource

                alert.dismiss(animated: true) {
                    print("alert dismiss")
                }
                
            case .success(let location):
                self.deleteTextField(alert.textFields)
                
                requestWeatherData(requestPurpose: .currentWeather,
                                   location: location)
                
            }
            
            alert.dismiss(animated: true) {
                print("alert dismiss")
            }
        })
        
        alert.addTextField { [self] field in
//            let latitude = self.locationViewController.getLocation()?.latitude
//            field.text = String(describing: latitude ?? CLLocationDegrees())
            field.placeholder = "위도"
        }
        
        alert.addTextField { field in
//            let longitude = self.locationViewController.getLocation()?.longitude
//            field.text = String(describing: longitude ?? CLLocationDegrees())
            field.placeholder = "경도"
        }
        
        return alert
    }()
    
    
    private lazy var inValidLocationAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치설정",
                                      message: "날씨를 받아올 위치의 위도와 경도를 입력해 주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))

        alert.addAction(UIAlertAction(title: "변경",
                                      style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            switch self.convertToValidLocation(alert.textFields) {
            case .failure(let error):
                self.tableView.delegate = self.emptyDelegate
                self.tableView.dataSource = self.emptyDataSource

                alert.dismiss(animated: true) {
                    print("alert dismiss")
                }
            case .success(let location):
                self.deleteTextField(alert.textFields)
                
                requestWeatherData(requestPurpose: .forecast,
                                   location: location)
            }
            alert.dismiss(animated: true) {
                print("alert dismiss")
            }
        })
       
        alert.addTextField { [self] field in
//            let latitude = self.locationViewController.getLocation()?.latitude
//            field.text = String(describing: latitude ?? CLLocationDegrees())
            field.placeholder = "위도"
        }
        
        alert.addTextField { field in
//            let longitude = self.locationViewController.getLocation()?.longitude
//            field.text = String(describing: longitude ?? CLLocationDegrees())
            field.placeholder = "경도"
        }
        return alert
    }()
}

extension TableViewController {
    private func drawTableView() {
        self.view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
        self.tableView.backgroundColor = UIColor.clear

        self.tableView.register(FiveDaysForecastCell.self,
                                forCellReuseIdentifier: "weatherCell")
        self.tableView.register(OpenWeatherHeaderView.self,
                                forHeaderFooterViewReuseIdentifier: "weatherHeaderView")

        let iconSize: CGFloat = 50
        self.tableView.rowHeight = CGFloat(iconSize)
        
        let headerViewSize: CGFloat = 120
        self.tableView.sectionHeaderHeight = headerViewSize
    }
    
    private func setRefreshControl() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        self.refreshControl.addTarget(self,
                                      action: #selector(requestLocationAgain),
                                      for: .valueChanged)
    }
}

extension TableViewController {
    @objc private func stopRefesh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func requestLocationAgain() {
        NotificationCenter
            .default
            .post(name: .requestLocationAgain,
                  object: nil)
    }
    
    @objc private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.dataSource = self.tableViewDataSource
            self.tableView.delegate = self.tableViewDelegate
            self.tableView.reloadData()
        }
    }
}

extension TableViewController {
    private func deleteTextField(_ fields: [UITextField]?) {
        guard let fields = fields else {
            return
        }
        for field in fields {
            field.text = nil
        }
    }
    
    private func changeToLocationType(_ latitude: String?, _ longitude: String?) -> Location? {
        guard let latitude = latitude, let longitude = longitude else {
            return nil
        }
        
        guard let lat = CLLocationDegrees(latitude),
              let long = CLLocationDegrees(longitude) else {
            return nil
        }
        
        return Location(lat, long)
    }
    
    private func isValidLocationRange(_ location: Location?) -> Bool {
        let maxLatitudeNumber: CLLocationDegrees = 90
        let minLatitudeNumber: CLLocationDegrees = -90
        let maxLongitudeNumber: CLLocationDegrees = 180
        let minLongitudeNumber: CLLocationDegrees = -180
        
        if let location = location,
           location.latitude < maxLatitudeNumber,
           location.latitude > minLatitudeNumber,
           location.longitude < maxLongitudeNumber,
           location.longitude > minLongitudeNumber {
            return true
        } else {
            return false
        }
    }
    
    enum ConvertLocationError: Error {
        case invalidLocation
    }
    
    private func convertToValidLocation(_ fields: [UITextField]?) -> Result<Location, Error> {
        let convertedLocation = changeToLocationType(fields?.first?.text, fields?.last?.text)
        if let convertedLocation = convertedLocation,
           self.isValidLocationRange(convertedLocation) {
            return .success(convertedLocation)
        } else {
            return .failure(ConvertLocationError.invalidLocation)
        }
    }
}
