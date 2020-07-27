//
//  WeatherServiceTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 21/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class WeatherServiceTestCase: XCTestCase {
    
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherSession = FakeURLSession(data: nil, response: nil, error: nil)
        let imageSession = FakeURLSession(data: nil, response: nil, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.correctWeatherData, response: FakeResponseData.responseKO, error: nil)
        let imageSession = FakeURLSession(data: nil, response: nil, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let imageSession = FakeURLSession(data: nil, response: nil, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherSession = FakeURLSession(data: nil, response: nil, error: FakeResponseData.error)
        let imageSession = FakeURLSession(data: nil, response: nil, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoImageData() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.correctWeatherData, response: FakeResponseData.responseOK, error: nil)
        let imageSession = FakeURLSession(data: nil, response: nil, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func testGetWeatherShouldPostFailedCallbackIfErrorWhileRetrievingImage() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.correctWeatherData, response: FakeResponseData.responseOK, error: nil)
        let imageSession = FakeURLSession(data: FakeResponseData.correctImageData, response: FakeResponseData.responseOK, error: FakeResponseData.error)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponseWhileRetrievingImage() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.correctWeatherData, response: FakeResponseData.responseOK, error: nil)
        let imageSession = FakeURLSession(data: FakeResponseData.correctImageData, response: FakeResponseData.responseKO, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            XCTAssertNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherSession = FakeURLSession(data: FakeResponseData.correctWeatherData, response: FakeResponseData.responseOK, error: nil)
        let imageSession = FakeURLSession(data: FakeResponseData.correctImageData, response: FakeResponseData.responseOK, error: nil)
        let service = WeatherService(weatherSession: weatherSession, imageSession: imageSession)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.getWeather(cityID: Weather.City.cityIDLamentin.rawValue) { (success, result, image) -> (Void) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(result)
            XCTAssertNotNil(image)
            XCTAssertEqual("Lamentin", result?.name)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

    }
    
}
