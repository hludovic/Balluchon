//
//  ConverterTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 20/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class ConverterTestCase: XCTestCase {
    var currency: Currency!
    var converter: Converter!

    override func setUp() {
        super .setUp()
        currency = Currency(success: true, timestamp: 1594953785, base: "EUR", date: "2020-07-17", rates: Currency.Rates.init(USD: 1.1384920000000001))
        converter = Converter(currency: currency)
    }
    
    func testConverterShouldDisplayErrorIfBadVelueToConvert() {
        // When
        converter.convertValue(mode: .eurToDol, value: "BadValue")
        // Then
        XCTAssertEqual(converter.errorMessage, "You didn't enter a number")
        XCTAssertEqual(nil, converter.resultMessage)
    }
    
    func testConverterShouldDisplayErrorIfNoValueToConvert() {
        // When
        converter.convertValue(mode: .dolToEur, value: nil)
        // Then
        XCTAssertEqual(converter.errorMessage, "We haven't received the number to convert.")
        XCTAssertEqual(nil, converter.resultMessage)
    }
    
    func testConverterShouldDisplayErrorIfNoConvertMode() {
        // When
        converter.convertValue(mode: nil, value: nil)
        // Then
        XCTAssertEqual(converter.errorMessage, "The mode of translation has not been indicated.")
        XCTAssertEqual(nil, converter.resultMessage)
    }
    
    func testConverterShouldDisplayErrorIfNoCurrency() {
        // Given
        converter = Converter()
        // When
        converter.convertValue(mode: .dolToEur, value: "10")
        // Then
        XCTAssertEqual(converter.errorMessage, "The currency is not downloaded.")
        XCTAssertEqual(nil, converter.resultMessage)
    }
    
    func testConverterStartwithGoodData_WhenConvertEuroToDollard_ThenItShouldDisplayResult() {
        // When
        converter.convertValue(mode: .eurToDol, value: "10")
        // Then 10 * 1.1384920000000001
        XCTAssertEqual(converter.resultMessage!, "11.38 $")
    }
    
    func testConverterStartwithGoodData_WhenConvertDollardToEuro_ThenItShouldDisplayResult() {
        // When
        converter.convertValue(mode: .dolToEur, value: "10")
        // Then 10 / 1.1384920000000001
        XCTAssertEqual(converter.resultMessage!, "8.78 €")
    }
        
    func testFechingDataAndConertAValueWhen_ONLINE_ThenTheResultIsNotNil() {
        // Given
        converter = Converter()
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        converter.fetchData { (success) -> (Void) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        converter.convertValue(mode: .dolToEur, value: "20")
        // Then
        XCTAssertNotNil(converter.resultMessage)
        XCTAssertNil(converter.errorMessage)
    }

}
