//
//  SearchViewControllerExtensionViewController.swift
//  WeatherApp
//
//  Created by Talor Levy on 6/10/23.
//

import UIKit

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func configureLocationsTableView() {
        locationsTableView.register(LocationTableViewCell.nib(), forCellReuseIdentifier: LocationTableViewCell.identifier)
        locationsTableView.layer.cornerRadius = 10
        locationsTableView.layer.masksToBounds = true
    }
}
