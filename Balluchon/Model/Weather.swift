//
//  Weather.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol WeatherDelegate: AnyObject {
    func displayResult(_ data: WeatherData)
    func displayError(_ text: String)
    func displayActivity(activity: Bool, cityID: Weather.City)
}

class Weather {
    weak var displayDelegate: WeatherDelegate?
    enum City: String {
        case firstCityID = "3579023" //  Lamentin
        case secondCityID = "5128581" // New York City
    }
    
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    
    private(set) var weatherData: WeatherData? {
        didSet { displayDelegate?.displayResult(weatherData!) }
    }
    
    private(set) var isLoading: (activity: Bool, city: Weather.City)? {
        willSet { displayDelegate?.displayActivity(activity: newValue!.activity, cityID: newValue!.city)
        }
    }
    
    func fetchData(cityID: City) {
        self.isLoading = (true, cityID)
        let weatherServiceFirst = WeatherService()
        weatherServiceFirst.getWeather(cityID: cityID.rawValue) { (success, result, imageData) -> (Void) in
            guard success, let result = result, let imageData = imageData else {
                self.isLoading = (false, cityID)
                self.errorMessage = "We were unable to recover the data"
                return
            }
            guard let temperature = Int(exactly: result.main.feels_like.rounded()) else {
                self.isLoading = (false, cityID)
                self.errorMessage = "Temperature data is not good"
                return
            }
            self.weatherData = WeatherData(cityID: cityID,
                                          cityName: result.name,
                                          cityImageData: imageData,
                                          cityDescription: result.weather[0].description,
                                          cityTemperature: "\(temperature)°C")
            self.isLoading = (false, cityID)
        }
    }
}

struct WeatherData {
    let cityID: Weather.City
    let cityName: String
    let cityImageData: Data
    let cityDescription: String
    let cityTemperature: String
}

struct WeatherResult: Codable {
    struct Main: Codable {
        let temp_max: Double
        let temp_min: Double
        let humidity: Double
        let feels_like: Double
        let temp: Double
    }
    struct Weather: Codable {
        let main: String
        let icon: String
        let description: String
    }
    let weather: [Weather]
    let main: Main
    let name: String
}
