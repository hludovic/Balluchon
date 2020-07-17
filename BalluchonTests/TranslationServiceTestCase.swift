//
//  TranslationServiceTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 16/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class TranslationServiceTestCase: XCTestCase {
    
    func testTranslationServiceShouldReturnCallbackErrorIfNoData() {
        // Given
        let session = FakeURLSession(data: nil, response: nil, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait")
        service.translate(from: .en, to: .fr, text: "Hello world, My name is Ludovic") { (success, result) -> (Void) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }
    
    func testTranslationServiceShouldReturnCallbackErrorIfWrongData() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.incorectData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait")
        service.translate(from: .en, to: .fr, text: "Hello world, My name is Ludovic") { (success, result) -> (Void) in
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testTranslationServiceShouldReturnCallbackSuccessIfAllIsOK() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.correctTranslationData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait")
        
        service.translate(from: .en, to: .fr, text: "Hello world, My name is Ludovic") { (success, result) -> (Void) in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    
}
