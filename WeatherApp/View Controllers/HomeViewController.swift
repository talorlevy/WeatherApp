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

    @IBOutlet var weatherTableView: UITableView!

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
