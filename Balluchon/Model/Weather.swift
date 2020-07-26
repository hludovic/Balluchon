//
//  Weather.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

/// Any class complying with this protocol will be delegated the tasks of displaying the result, error messages and activity indication.
protocol WeatherDelegate: AnyObject {
    func displayResult(_ data: WeatherData)
    func displayError(_ text: String)
    func displayActivity(activity: Bool, cityID: Weather.City)
}

/// This class retrieves and displays weather data.
class Weather {
    weak var displayDelegate: WeatherDelegate?
    
    /// Lists of two citys id that can be performed with a Weather.
    enum City: String {
        case cityIDLamentin = "3579023"
        case cityIDNewYork = "5128581"
    }
    
    /// This property sets the value of the error message that should be displayed.
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    
    /// This property sets the value of the data that should be displayed.
    private(set) var weatherData: WeatherData? {
        didSet { displayDelegate?.displayResult(weatherData!) }
    }
    
    /// This property may or may not indicate loading activity.
    private(set) var isLoading: (activity: Bool, city: Weather.City)? {
        willSet { displayDelegate?.displayActivity(activity: newValue!.activity, cityID: newValue!.city)
        }
    }
    
    /// This function retrieves and displays the value of the weather. Displays also an animation during this operation.
    /// - Parameters:
    ///   - cityID: The id of the city from which we'd like to retrieve the weather data.
    ///   - completion: The closure called after retrieval.
    ///   - success: Returns "true" if the recovery is a success.
    func fetchData(cityID: City, completion: @escaping (_ success: Bool) -> (Void)) {
        self.isLoading = (true, cityID)
        let weatherService = WeatherService()
        weatherService.getWeather(cityID: cityID.rawValue) { (success, result, imageData) -> (Void) in
            guard success, let result = result, let imageData = imageData else {
                self.isLoading = (false, cityID)
                self.errorMessage = "We were unable to recover the data"
                completion(false)
                return
            }
            guard let temperature = Int(exactly: result.main.feels_like.rounded()) else {
                self.isLoading = (false, cityID)
                self.errorMessage = "Temperature data is not good"
                completion(false)
                return
            }
            self.weatherData = WeatherData(cityID: cityID,
                                          cityName: result.name,
                                          cityImageData: imageData,
                                          cityDescription: result.weather[0].description,
                                          cityTemperature: "\(temperature)°C")
            self.isLoading = (false, cityID)
            completion(true)
        }
    }
}

/// Structure of the data to be displayed.
struct WeatherData {
    let cityID: Weather.City
    let cityName: String
    let cityImageData: Data
    let cityDescription: String
    let cityTemperature: String
}

/// Structure of the data received by the WeatherService.
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
