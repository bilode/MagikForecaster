//
//  WeatherDetailViewController.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    var viewModel: WeatherDetailViewModel? {
        didSet {
            self.fillUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fillUI()
    }

    private func fillUI() {

        guard self.isViewLoaded,
            let viewModel = self.viewModel else {
                return
        }


    }
}
