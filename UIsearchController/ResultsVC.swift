//
//  ResultsVC.swift
//  UIsearchController
//
//  Created by Ben Huggins on 2/12/23.
//

import UIKit
import MapKit


protocol sendBackLocationSearchTableDelegate: class {           //1
    func sendBackData(_ controller: ResultsVC, placeMark: MKPlacemark)
}
   
class ResultsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = {
       let table = UITableView()
       table.register(LocationsSearchTC.self, forCellReuseIdentifier: LocationsSearchTC.identifier)
       // table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var mapView: MKMapView? = nil
    var matchingItems:[MKMapItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: sendBackLocationSearchTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.backgroundColor = .blue
        navigationController?.navigationBar.isHidden = true
        tableView.frame = view.bounds
       tableView.delegate = self
       tableView.dataSource = self
        view.addSubview(tableView)
    }
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: LocationsSearchTC.identifier) as! LocationsSearchTC
        
        let selectedItem = matchingItems[indexPath.row].placemark
       cell.configureSelectedItem(selectedItem: selectedItem)  /// sent to the custom cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeMark = matchingItems[indexPath.row].placemark
  
        self.delegate?.sendBackData(self, placeMark: placeMark)  //3
        dismiss(animated: true, completion: nil)
    }
}

extension ResultsVC: UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
      //  searchController.searchResultsController?.view.isHidden = false
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
           request.naturalLanguageQuery = searchBarText
           request.region = mapView.region
           let search = MKLocalSearch(request: request)     /// This is the search request that gets
        search.start { [self] response, _ in
               guard let response = response else { return }
               self.matchingItems = response.mapItems          // these are the items that get returned
            print("Matching Items: ", self.matchingItems)
               self.tableView.reloadData()
       }
    }
}
