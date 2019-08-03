//
//  ViewController.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 02/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        WSManager.shared.fetchWeather(lat: "48.85341", lon: "2.3488") { result in

            switch result {
            case .success(let weather):
                print("Success!!!")
                print(weather)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
