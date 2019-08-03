//
//  WeatherViewController.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController {

    var viewModel: WeatherListViewModel? {
        didSet {
            self.fillUI()
        }
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.fillUI()

        WSManager.shared.fetchWeather(lat: "48.85341", lon: "2.3488") { result in

            switch result {
            case .success(let store):
                self.viewModel = WeatherListViewModel(withStore: store)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fillUI() {

        guard self.isViewLoaded,
           self.viewModel != nil else {
                return
        }

        self.tableView.dataSource = self
        self.tableView.delegate = self

        tableView.reloadData()
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


}