//
//  WeatherService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class WeatherService {
    // --- API KEY ---
    private let apiKey = valueForAPIKey(named: "ApiOpenWeather")
    // --- --- --- ---
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    /// Dependency injection
    /// - Parameter session: You can inject a fake URLSession for unit tests.
    convenience init(session: URLSession) {
        self.init()
        self.session = session
    }
    
    /// This method retrieves weather data on ApiOpenWeather.
    /// - Parameters:
    ///   - cityID: The id of the city from which we'd like to retrieve the weather data.
    ///   - callback: The closure called after retrieval.
    ///   - success: Returns "true" if the retrive is a succes.
    ///   - result: The retrieved "WeatherResult".
    ///   - icon: The retrieved weather illustration.
    func getWeather(cityID: String, callback: @escaping (_ success: Bool, _ result: WeatherResult?, _ icon: Data?) -> (Void)) {
        let urlRequest = URL(string: "\(baseURL)?id=\(cityID)&units=metric&appid=\(apiKey)")!
        task?.cancel()
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    callback(false, nil, nil)
                    return
                }
                self.getIcon(id: responseJSON.weather[0].icon) { (data) -> (Void) in
                    guard let data = data else {
                        callback(false, nil, nil)
                        return
                    }
                    callback(true, responseJSON, data)
                }
            }
        })
        task?.resume()
    }
    
    private func getIcon(id: String, completion: @escaping (Data?) -> (Void)) {
        let urlRequest = URL(string: "https://openweathermap.org/img/w/\(id).png")!
        task?.cancel()
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("ERROR")
                    completion(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("ERROR")
                    completion(nil)
                    return
                }
                completion(data)
            }
        })
        task?.resume()
    }
}
