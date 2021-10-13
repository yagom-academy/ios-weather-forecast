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
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
        
        weatherModel.currentData.bind { [weak self] _ in
            guard let self = self else { return }
            self.bindHeaderView()
        }
        
        weatherModel.isDataTaskError?.bind { [weak self] _ in
            guard let self = self else { return }
            self.failureFetchingWeather(error: nil)
        }
        
        weatherModel.forecastData.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.weatherTableView.reloadData()
            }
        }
    }
}

extension WeatherViewController {
    private func configureTableView() {
        view.addSubview(weatherTableView)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindHeaderView() {
        DispatchQueue.main.async {
            self.weatherHeaderView.configureContents(address: self.weatherModel.getAddress(),
                                                     minTempature: self.weatherModel.getTempature(kind: .min),
                                                     maxTempature: self.weatherModel.getTempature(kind: .max),
                                                     currentTempature: self.weatherModel.getTempature(kind: .current),
                                                     iconData: self.weatherModel.currentData.value?.imageData)
            self.weatherTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.numberOfCellCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = weatherModel.getCellViewModel(at: indexPath)
        
        guard let icon = cellViewModel?.weather.first?.icon,
              let url = URL(string: WeatherAPI.icon.url + icon) else {
            return UITableViewCell()
        }

        NetworkManager().dataTask(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    cell.configureContents(date: self.weatherModel.getForecastTime(cellViewModel?.forecastTime),
                                           tempature: "1111",
                                           weatherImage: UIImage(data: data))
                }

            case .failure(_):
                break
            }
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
    private func failureFetchingWeather(error: Error?) {
        let alert = UIAlertController.generateErrorAlertController(message: error?.localizedDescription)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
