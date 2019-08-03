//
//  WeatherCell.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet var content: UIView!

    @IBOutlet weak var dateLabel: UILabel!

    var viewModel: WeatherCellViewModel? {
        didSet {
            self.fillUI()
        }
    }

    /*****************************************************************************/
    // MARK: - Initializers

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }



    private func fillUI() {
        guard let viewModel = self.viewModel else {
            return
        }

        self.dateLabel.text = viewModel.stringDate
    }
}
