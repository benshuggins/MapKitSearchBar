//
//  ViewController.swift
//  UIsearchController
//
//  Created by Ben Huggins on 2/12/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
   
    var searchController = UISearchController(searchResultsController: ResultsVC())
    var selectedPin: MKPlacemark? = nil
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.addSubview(mapView)
        configureMap()
        navigationItem.searchController = searchController
  
        let resultsVC = ResultsVC()
        
        resultsVC.delegate = self
        searchController = UISearchController(searchResultsController: resultsVC)
   
        searchController.searchResultsUpdater = resultsVC as UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = true
  
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = searchController
        
        searchController.hidesNavigationBarDuringPresentation = true
        resultsVC.mapView = mapView
    }
    
    func configureMap() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// Need to make it back here to place an annotation on the map
extension ViewController: sendBackLocationSearchTableDelegate {
   
    func sendBackData(_ controller: ResultsVC, placeMark placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear the existing annotation
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
       
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
