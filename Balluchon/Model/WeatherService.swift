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
    private let session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    static let shared = WeatherService()
    private init() {}
//    private let idLamentin = "3579023"
//    private let idNewYork = "5128581"
    
    private func urlRequest(cityID: String) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?id=\(cityID)&units=metric&appid=\(apiKey)")!
        
    }
    
    func getWeather(cityID: String, callback: @escaping (Bool, WeatherResult?, Data?) -> (Void)) {
        
        task?.cancel()
        task = session.dataTask(with: urlRequest(cityID: cityID), completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("ERROR-----1")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("ERROR-----2")
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(WeatherResult.self, from: data) else {
                    print("ERROR-----3")
                    return
                }
                
                self.getIcon(id: responseJSON.weather[0].icon) { (data) -> (Void) in
                    guard let data = data else {
                        print("ERROR")
                        return
                    }
                    callback(true, responseJSON, data)
                    print(responseJSON.name)

                }
            }
        })
        task?.resume()
    }
    
    func getIcon(id: String, completion: @escaping (Data?) -> (Void)) {
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
