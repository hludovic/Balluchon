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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCase() {
        let currency = Currency(success: true, timestamp: 1594953785, base: "EUR", date: "2020-07-17", rates: Currency.Rates.init(USD: 1.1384920000000001))
        let converter = Converter(currency: currency)
        converter.convertValue(mode: .eurToDol, value: "24")
        print(converter.resultMessage!)
        
        
    }
}
