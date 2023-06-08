//
//  ViewController.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/6/23.
//

import CoreLocation
import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // MARK: - @IBOutlet

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!

    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        configureUI()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
}
