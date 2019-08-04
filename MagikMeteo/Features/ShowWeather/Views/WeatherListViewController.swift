//
//  WeatherViewController.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

protocol WeatherListViewControllerDelegate: class {

    func didPickWeatherEntry(_ weather: Weather)
}


class WeatherListViewController: UIViewController {

    weak var delegate: WeatherListViewControllerDelegate?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!


    var viewModel: WeatherListViewModel? {
        didSet {
            self.fillUI()
        }
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fillUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isBeingPresented || self.isMovingToParent {
            self.viewModel?.viewIsReady()
        }
    }

    private func fillUI() {

        guard self.isViewLoaded,
            let viewModel = self.viewModel else {
                return
        }

        self.tableView.dataSource = self
        self.tableView.delegate = self

        viewModel.weatherStore.bindAndFire { [weak self] store in
            self?.tableView.reloadData()
        }

        viewModel.selectedWeather.bind { [weak self] weather in
            if weather != nil {
                self?.delegate?.didPickWeatherEntry(weather!)
            }
        }


        viewModel.loadingMessage.bindAndFire { [weak self] message in
            self?.setLoadingMessage(message)
        }

        viewModel.errorMessage.bindAndFire { [weak self] message in
            self?.errorMessageLabel.text = message
        }

        tableView.reloadData()
    }


    private func setLoadingMessage(_ message: String) {

        if message.isEmpty {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }

        self.loadingMessageLabel.text = message
    }
}


/*****************************************************************************/
// MARK: - UITableViewDataSource / UITableViewDelegate

extension WeatherListViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return min(100,
            self.view.safeAreaLayoutGuide.layoutFrame.height / CGFloat(self.viewModel!.minNumberOfVisibleElements))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel!.numberOfElements
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: WeatherCell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? WeatherCell {

            cell.viewModel = self.viewModel!.viewModelForElement(withIndex: indexPath.row)

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.didSelectRow(atIndex: indexPath.row)
    }
}
