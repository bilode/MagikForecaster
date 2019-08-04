//
//  WeatherListCoordinator.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 04/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherListCoordinator {

    let window: UIWindow

    var weatherListVC: WeatherListViewController
    var weatherDetailVC: WeatherDetailViewController?

    var presenter: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.presenter = UINavigationController()

        self.weatherListVC = UIStoryboard.loadFromMain("weatherListViewController") as! WeatherListViewController
    }

    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()

        self.weatherListVC.viewModel = WeatherListViewModel(withLocationManager: LocationManager.shared, weatherStore: WeatherStore())
        self.weatherListVC.title = "Pick one"
        self.weatherListVC.delegate = self
        presenter.pushViewController(self.weatherListVC, animated: true)
    }
}


/*****************************************************************************/
// MARK: - WeatherListViewControllerDelegate
extension WeatherListCoordinator: WeatherListViewControllerDelegate {

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    func didPickWeatherEntry(_ weather: Weather) {

        self.weatherDetailVC = UIStoryboard.loadFromMain("weatherDetailViewController") as? WeatherDetailViewController
        self.weatherDetailVC?.viewModel = WeatherDetailViewModel(fromWeatherEntry: weather)
        if let date = weather.date {
            self.weatherDetailVC?.title = WeatherListCoordinator.formatter.string(from: date)
        }
        self.presenter.pushViewController(weatherDetailVC!, animated: true)
    }
}
