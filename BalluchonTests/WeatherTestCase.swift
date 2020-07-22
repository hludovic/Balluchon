//
//  WeatherTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 21/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class WeatherTestCase: XCTestCase {
    func testWeather_ONLINE_Success() {
        let weather = Weather()
        
        let expectation = XCTestExpectation(description: "wait")
        weather.fetchData(cityID: .cityIDLamentin) { (success) -> (Void) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(weather.weatherData?.cityName, "Lamentin")
    }
}
