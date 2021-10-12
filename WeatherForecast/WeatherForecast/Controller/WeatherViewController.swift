//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherViewController: UIViewController {
    
    enum NameSpace {
        enum TableView {
            static let rowheight: CGFloat = 50
            static let heightHeaderView: CGFloat = 120
            static let backGroundImage = "background"
        }
    }
    
    private var weatherModel = WeatherViewModel()
    private var weatherHeaderView = WeatherHeaderView()
    
    private var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherTableViewCell.self,
                           forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.rowHeight = NameSpace.TableView.rowheight
        tableView.backgroundView = UIImageView(image: UIImage(named: NameSpace.TableView.backGroundImage))
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
        weatherModel.currentData.bind({ [weak self] in
            DispatchQueue.main.async {
                self?.weatherHeaderView.configureContents(address: "김김김",
                                                    minTempature: "1111111",
                                                    maxTempature: "111111111",
                                                    currentTempature: "111111",
                                                    iconData: nil)
                self?.weatherTableView.reloadData()
            }
        })
    }
}

extension WeatherViewController {
    func configureTableView() {
        view.addSubview(weatherTableView)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.forecastData.value?.list.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return NameSpace.TableView.heightHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return weatherHeaderView
    }
}

extension WeatherViewController {
    //    private func failureFetchingWeather(error: Error?) {
    //        let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
    //        DispatchQueue.main.async {
    //            self.present(alert, animated: true, completion: nil)
    //        }
    //    }
}
