//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/6/23.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    static let identifier = "DailyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Daily) {
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.iconImageView.contentMode = .scaleAspectFit
        let main = model.weather[0].main.rawValue
        if main == "Clear" {
            self.iconImageView.image = UIImage(named: "clear")
        } else if main == "Rain" {
            self.iconImageView.image = UIImage(named: "rain")
        } else {
            self.iconImageView.image = UIImage(named: "cloud")
        }
        self.lowTempLabel.text = "\(Constants.kelvinToFahrenheit(kelvin: model.temp.min))°"
        self.highTempLabel.text = "\(Constants.kelvinToFahrenheit(kelvin: model.temp.max))°"
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
}
