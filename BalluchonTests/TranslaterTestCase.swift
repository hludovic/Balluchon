//
//  TranslaterTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 20/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class TranslaterTestCase: XCTestCase {

    func testTranslaterShouldDisplayErrorIfNoTextToTranslate() {
        let translater = Translater()

        translater.translate(text: nil, to: .en) { (_) -> Void in
        }
        XCTAssertEqual(translater.errorMessage, "First enter a text to be translated.")
        XCTAssertNil(translater.resultMessage)
    }

    func testTranslaterShouldDisplayErrorIfNoLanguageDestination() {
        let translater = Translater()

        translater.translate(text: "Bonjour", to: nil) { (_) -> Void in
        }
        XCTAssertEqual(translater.errorMessage, "There is no information on the language of origin or destination.")
        XCTAssertNil(translater.resultMessage)
    }

    func testTranslatingWhen_ONLINE_ThenTheResultIsSuccess() {
        let translater = Translater()

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translater.translate(text: "Bonjour", to: .en) { (_) -> Void in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(translater.resultMessage?.data.translations[0].translatedText, "Hello")
        XCTAssertNil(translater.errorMessage)
    }

//    func testTranslatingWhen_OFFLINE_ThenDisplayErrorMessage() {
//        let translater = Translater()
//        
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        translater.translate(text: "Bonjour", to: .en) { (success) -> (Void) in
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.5)
//        
//        XCTAssertEqual(translater.errorMessage, "The text could not be translated.")
//    }
}
