//
//  DeviseServiceTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class ConverterServiceTestCase: XCTestCase {
    func testConverterServiceShouldPostFailedCallbackIfNoData() {
        // Given
        let session = FakeURLSession(data: nil, response: nil, error: nil)
        let currencyService = ConverterService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        currencyService.getCurrency { (response, currency) -> (Void) in
            // Then
            XCTAssertFalse(response)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testConverterServiceShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.correctCurrencyData, response: FakeResponseData.responseKO, error: nil)
        let currencyService = ConverterService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        currencyService.getCurrency { (response, currency) -> (Void) in
            // Then
            XCTAssertFalse(response)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testConverterServiceShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let currencyService = ConverterService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        currencyService.getCurrency { (response, currency) -> (Void) in
            // Then
            XCTAssertFalse(response)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testConverterServiceShouldPostFailedCallbackIfError() {
        // Given
        let session = FakeURLSession(data: nil, response: nil, error: FakeResponseData.error)
        let currencyService = ConverterService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        currencyService.getCurrency { (response, currency) -> (Void) in
            // Then
            XCTAssertFalse(response)
            XCTAssertNil(currency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCurrencyServiceShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let currencyService = ConverterService(
            session: FakeURLSession(data: FakeResponseData.correctCurrencyData, response: FakeResponseData.responseOK, error: nil))
        
        let expectation = XCTestExpectation(description: "Wait queue")
        // When
        currencyService.getCurrency { (response, currency) -> (Void) in
            // Then
            XCTAssertEqual(1.1384920000000001, currency!.rates.USD)
            XCTAssertTrue(response)
            XCTAssertNotNil(currency)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }

}
