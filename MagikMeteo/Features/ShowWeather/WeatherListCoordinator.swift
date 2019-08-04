//
//  WeatherListCoordinator.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 04/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherListCoordinator {

    let weatherStore: WeatherStore

    var weatherListVC: WeatherListViewController?
    var weatherDetailVC: WeatherDetailViewController?

    var presenter: UINavigationController

    init(withPresenter presenter: UINavigationController, store: WeatherStore) {
        self.weatherStore = store
        self.presenter = presenter
    }
}
