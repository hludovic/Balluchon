//
//  Weather.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 18/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation




struct WeatherResult: Codable {
    struct Main: Codable {
        let temp_max: Double
        let temp_min: Double
        let humidity: Double
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
