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
    @IBOutlet weak var firstCityBackground: UIView!
    @IBOutlet weak var firstCityActivityIndicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                firstCityActivityIndicator.style = .medium
            }
        }
    }

    @IBOutlet weak var secondCityImage: UIImageView!
    @IBOutlet weak var secondCityName: UILabel!
    @IBOutlet weak var secondCityTemperature: UILabel!
    @IBOutlet weak var secondCityDescription: UILabel!
    @IBOutlet weak var secondCityBackground: UIView!
    @IBOutlet weak var secondCityActivityIndicator: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                firstCityActivityIndicator.style = .medium
            }
        }
    }

    // MARK: - Properties
    private let weather = Weather()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weather.displayDelegate = self

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItem = refreshButton

        firstCityBackground.layer.cornerRadius = 10
        firstCityBackground.layer.shadowColor = UIColor.black.cgColor
        firstCityBackground.layer.shadowOffset = .zero
        firstCityBackground.layer.shadowRadius = 3
        firstCityBackground.layer.shadowOpacity = 0.5

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
        weather.fetchData(cityID: .cityIDLamentin) { (success) -> Void in
            guard success else {
                self.displayError("We could not retrieve data from the first city")
                return
            }
        }
        weather.fetchData(cityID: .cityIDNewYork) { (success) -> Void in
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
        DispatchQueue.main.async {
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
    }

    func displayError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func displayActivity(activity: Bool, cityID: Weather.City) {
        DispatchQueue.main.async {
            switch cityID {
            case .cityIDLamentin:
                if activity {
                    self.firstCityName.isHidden = true
                    self.firstCityTemperature.isHidden = true
                    self.firstCityDescription.isHidden = true
                    self.firstCityActivityIndicator.startAnimating()
                } else {
                    self.firstCityName.isHidden = false
                    self.firstCityTemperature.isHidden = false
                    self.firstCityDescription.isHidden = false
                    self.firstCityActivityIndicator.stopAnimating()
                }
            case .cityIDNewYork:
                if activity {
                    self.secondCityTemperature.isHidden = true
                    self.secondCityName.isHidden = true
                    self.secondCityDescription.isHidden = true
                    self.secondCityActivityIndicator.startAnimating()
                } else {
                    self.secondCityTemperature.isHidden = false
                    self.secondCityName.isHidden = false
                    self.secondCityDescription.isHidden = false
                    self.secondCityActivityIndicator.stopAnimating()
                }
            }
        }
    }
}
