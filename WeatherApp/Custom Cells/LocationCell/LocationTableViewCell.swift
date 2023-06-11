//
//  LocationTableViewCell.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/10/23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    static let identifier = "LocationTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "LocationTableViewCell", bundle: nil)
    }
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily) {
        self.titleLabel.text = ""
        self.timeLabel.text = ""
        self.descriptionLabel.text = model.summary
        self.currentTempLabel.text = "\(model.temp.day)°"
        self.highTempLabel.text = "H:\(model.temp.max)°"
        self.lowTempLabel.text = "L:\(model.temp.min)°"
    }
}
