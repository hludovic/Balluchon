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

    func testFetchDataWhen_ONLINE_ThenTheResultIsSuccess() {
        let weather = Weather()
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weather.fetchData(cityID: .cityIDLamentin) { (_) -> Void in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(weather.weatherData?.cityName, "Lamentin")
    }

//    func testFetchDataWhen_OFFLINE_ThenDisplayErrorMessage() {
//        let weather = Weather()
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        weather.fetchData(cityID: .cityIDLamentin) { (success) -> (Void) in
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//
//        XCTAssertEqual(weather.errorMessage, "We were unable to recover the data")
//    }

}
