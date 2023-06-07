//
//  ViewController.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/6/23.
//

import CoreLocation
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    
    var viewModel: HomeViewModel?
    

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        
        // Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)

        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func initViewModel() {
        viewModel = HomeViewModel()
    }
    
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let currentLocation = self?.currentLocation else { return }
            let lat = currentLocation.coordinate.latitude
            let long = currentLocation.coordinate.longitude
            self?.viewModel?.fetchWeatherData(lat: lat, long: long) { result in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        self?.table.reloadData()
                        self?.table.tableHeaderView = self?.createTableHeader()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))

        headerView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Current Location"

        guard let currentWeather = viewModel?.currentWeather else { return UIView() }

        tempLabel.text = "\(currentWeather.temp)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        summaryLabel.text = currentWeather.weather[0].description.rawValue
        
        return headerView
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 cell that is a collectiontableviewcell
        if section == 0 {
            return 1
        }
        
        return viewModel?.models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let hourlyModels = viewModel?.hourlyModels else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        } else {
            guard let models = viewModel?.models else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: models[indexPath.row])
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}








//    func requestWeatherForLocation2() {
//        guard let currentLocation = currentLocation else { return }
//        let long = currentLocation.coordinate.longitude
//        let lat = currentLocation.coordinate.latitude
//
//        let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&appid=6af3f24188f3759e19188165184e3d7c"
//
//        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
//
//            // Validation
//            guard let data = data, error == nil else {
//                print("something went wrong")
//                return
//            }
//
//            // Convert data to models/some object
//
//            var json: WeatherResponse?
//
//            do {
//                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
//            }
//            catch {
//                print("error: \(error)")
//            }
//
//            guard let result = json else { return }
//
//            let entries = result.daily
//
//            self.models.append(contentsOf: entries)
//
//            let current = result.current
//            self.currentWeather = current
//
//            self.hourlyModels = result.hourly
//
//            // Update user interface
//            DispatchQueue.main.async { [weak self] in
//                self?.table.reloadData()
//
//                self?.table.tableHeaderView = self?.createTableHeader()
//            }
//
//        }).resume()
//    }
