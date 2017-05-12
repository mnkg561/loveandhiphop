//
//  LocationSearchViewController.swift
//  LoveAndHiphop
//
//  Created by hollywoodno on 5/11/17.
//  Copyright © 2017 Mogulla, Naveen. All rights reserved.
//

import UIKit
import GooglePlaces

protocol LocationSearchViewControllerDelegate {
  func LocationSearchViewController(locationSearchViewController: LocationSearchViewController, selectedLocation: GMSPlace)
}

class LocationSearchViewController: UIViewController, GMSAutocompleteViewControllerDelegate {
  
  // MARK: Properties
  var address: String?
  var delegate: LocationSearchViewControllerDelegate?
  
  @IBAction func onSearch(_ sender: UIButton) {
    let autocompleteController = GMSAutocompleteViewController()
    let filter = GMSAutocompleteFilter()
    filter.type = .city
    autocompleteController.autocompleteFilter = filter
    autocompleteController.delegate = self
    present(autocompleteController, animated: true, completion: nil)
  }
  
  // MARK: GMSAutocomplete Delegates
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // Signal out the user's address selection.
    self.delegate?.LocationSearchViewController(locationSearchViewController: self, selectedLocation: place)
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
  
}
