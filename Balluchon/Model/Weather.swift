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
        case firstCityID = "3579023"
        case secondCityID = "5128581"
    }
    
    func fetchData(cityID: City) {
        displayDelegate?.displayActivity(activity: true, cityID: cityID)
        let weatherServiceFirst = WeatherService()
        weatherServiceFirst.getWeather(cityID: cityID.rawValue) { (success, result, imageData) -> (Void) in
            guard success, let result = result, let imageData = imageData else {
                self.displayDelegate?.displayActivity(activity: false, cityID: cityID)
                self.displayDelegate?.displayError("We were unable to recover the data")
                return
            }
            guard let temperature = Int(exactly: result.main.feels_like.rounded()) else {
                self.displayDelegate?.displayActivity(activity: false, cityID: cityID)
                self.displayDelegate?.displayError("Temperature data is not good")
                return
            }
            let weatherData = WeatherData(cityID: cityID,
                                          cityName: result.name,
                                          cityImageData: imageData,
                                          cityDescription: result.weather[0].description,
                                          cityTemperature: "\(temperature)°C")
            self.displayDelegate?.displayActivity(activity: false, cityID: cityID)
            self.displayDelegate?.displayResult(weatherData)
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
