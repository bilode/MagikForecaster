//
//  WeatherDetailViewController.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var tempSectionTitleLabel: UILabel!
    @IBOutlet weak var temp2MLabel: UILabel!
    @IBOutlet weak var tempSolLabel: UILabel!

    @IBOutlet weak var pressionSectionTitleLabel: UILabel!
    @IBOutlet weak var pressionNiveauMerLabel: UILabel!

    @IBOutlet weak var risqueNeigeLabel: UILabel!


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

        self.tempSectionTitleLabel.text = viewModel.temperature
        self.temp2MLabel.text = viewModel.temp2m
        self.tempSolLabel.text = viewModel.tempSol

        self.pressionSectionTitleLabel.text = viewModel.pression
        self.pressionNiveauMerLabel.text = viewModel.pressionNiveauMer

        self.risqueNeigeLabel.text = viewModel.risqueNeigeValue
    }
}
