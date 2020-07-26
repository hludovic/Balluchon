//
//  WeatherViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var firstCityImage: UIImageView!
    @IBOutlet weak var firstCityName: UILabel!
    @IBOutlet weak var firstCityTemperature: UILabel!
    @IBOutlet weak var firstCityDescription: UILabel!
    @IBOutlet weak var FirstCityBackground: UIView!
    @IBOutlet weak var firstCityActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var secondCityImage: UIImageView!
    @IBOutlet weak var secondCityName: UILabel!
    @IBOutlet weak var secondCityTemperature: UILabel!
    @IBOutlet weak var secondCityDescription: UILabel!
    @IBOutlet weak var secondCityBackground: UIView!
    @IBOutlet weak var secondCityActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let weather = Weather()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.displayDelegate = self
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItem = refreshButton
        
        FirstCityBackground.layer.cornerRadius = 10
        FirstCityBackground.layer.shadowColor = UIColor.black.cgColor
        FirstCityBackground.layer.shadowOffset = .zero
        FirstCityBackground.layer.shadowRadius = 3
        FirstCityBackground.layer.shadowOpacity = 0.5

        secondCityBackground.layer.cornerRadius = 10
        secondCityBackground.layer.shadowColor = UIColor.black.cgColor
        secondCityBackground.layer.shadowOffset = .zero
        secondCityBackground.layer.shadowRadius = 3
        secondCityBackground.layer.shadowOpacity = 0.5
        
        refreshData()
    }
        
}

// MARK: - Private Methods
private extension WeatherViewController {
    @objc func refreshData() {
        weather.fetchData(cityID: .cityIDLamentin) { (success) -> (Void) in
            guard success else {
                self.displayError("We could not retrieve data from the first city")
                return
            }
        }
        weather.fetchData(cityID: .cityIDNewYork) { (success) -> (Void) in
            guard success else {
                self.displayError("We could not retrieve data from the second city")
                return
            }
        }
    }
}

// MARK: - WeatherDelegate
extension WeatherViewController: WeatherDelegate {
    func displayResult(_ data: WeatherData) {
        switch data.cityID {
        case .cityIDLamentin :
            self.firstCityName.text = data.cityName
            self.firstCityImage.image = UIImage(data: data.cityImageData)
            self.firstCityDescription.text = data.cityDescription
            self.firstCityTemperature.text = data.cityTemperature
        case .cityIDNewYork :
            self.secondCityName.text = data.cityName
            self.secondCityImage.image = UIImage(data: data.cityImageData)
            self.secondCityDescription.text = data.cityDescription
            self.secondCityTemperature.text = data.cityTemperature
        }
    }
    
    func displayError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func displayActivity(activity: Bool, cityID: Weather.City) {
        switch cityID {
        case .cityIDLamentin:
            if activity {
                firstCityName.isHidden = true
                firstCityTemperature.isHidden = true
                firstCityDescription.isHidden = true
                firstCityActivityIndicator.startAnimating()
            } else {
                firstCityName.isHidden = false
                firstCityTemperature.isHidden = false
                firstCityDescription.isHidden = false
                firstCityActivityIndicator.stopAnimating()
            }
        case .cityIDNewYork:
            if activity {
                secondCityTemperature.isHidden = true
                secondCityName.isHidden = true
                secondCityDescription.isHidden = true
                secondCityActivityIndicator.startAnimating()
            } else {
                secondCityTemperature.isHidden = false
                secondCityName.isHidden = false
                secondCityDescription.isHidden = false
                secondCityActivityIndicator.stopAnimating()
            }
        }
    }
}
