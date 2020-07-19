//
//  WeatherViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var firstCityImage: UIImageView!
    @IBOutlet weak var firstCityName: UILabel!
    @IBOutlet weak var firstCityTemperature: UILabel!
    @IBOutlet weak var firstCityDescription: UILabel!
    @IBOutlet weak var FirstCityBackground: UIView!
    
    @IBOutlet weak var secondCityImage: UIImageView!
    @IBOutlet weak var secondCityName: UILabel!
    @IBOutlet weak var secondCityTemperature: UILabel!
    @IBOutlet weak var secondCityDescription: UILabel!
    @IBOutlet weak var secondCityBackground: UIView!
    
    enum City: String {
        case firstCityID = "3579023"
        case secondCityID = "5128581"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        fetchData(cityID: .firstCityID)
        fetchData(cityID: .secondCityID)
    }
    
    func fetchData(cityID: City) {
        let weatherServiceFirst = WeatherService()
        weatherServiceFirst.getWeather(cityID: cityID.rawValue) { (success, result, imageData) -> (Void) in
            guard success, let result = result, let imageData = imageData else {
                print("ERROR")
                return
            }
            guard let temperature = Int(exactly: result.main.feels_like.rounded()) else {
                print("ERROR")
                return
            }
            switch cityID {
            case .firstCityID :
                self.firstCityName.text = result.name
                self.firstCityImage.image = UIImage(data: imageData)
                self.firstCityDescription.text = result.weather[0].description
                self.firstCityTemperature.text = "\(temperature)°C"
            case .secondCityID :
                self.secondCityName.text = result.name
                self.secondCityImage.image = UIImage(data: imageData)
                self.secondCityDescription.text = result.weather[0].description
                self.secondCityTemperature.text = "\(temperature)°C"
            }
        }
    }
}
