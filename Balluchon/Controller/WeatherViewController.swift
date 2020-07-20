//
//  WeatherViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, WeatherDelegate {
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
    private let weather = Weather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.displayDelegate = self
        addRefreshButton()
        
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
    
    func addRefreshButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
    }
    
    @objc func refreshData() {
        weather.fetchData(cityID: .firstCityID)
        weather.fetchData(cityID: .secondCityID)
    }
    
    func displayResult(_ data: WeatherData) {
        switch data.cityID {
        case .firstCityID :
            self.firstCityName.text = data.cityName
            self.firstCityImage.image = UIImage(data: data.cityImageData)
            self.firstCityDescription.text = data.cityDescription
            self.firstCityTemperature.text = data.cityTemperature
        case .secondCityID :
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
        case .firstCityID:
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
        case .secondCityID:
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
