//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/8/23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    static let identifier = "HourlyCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: Current) {
        hourLabel.text = getHourForDate(Date(timeIntervalSince1970: Double(model.dt)))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = UIImage(named: "")
        let main = model.weather[0].main.rawValue
        if main == "Clear" {
            self.iconImageView.image = UIImage(named: "clear")
        } else if main == "Rain" {
            self.iconImageView.image = UIImage(named: "rain")
        } else {
            self.iconImageView.image = UIImage(named: "cloud")
        }
        tempLabel.text = String(Constants.kelvinToFahrenheit(kelvin: model.temp)) + "°"
    }
    
    func getHourForDate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // Example: 9 AM
        return formatter.string(from: inputDate)
    }

}
