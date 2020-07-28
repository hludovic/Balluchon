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

    func testTranslationServiceShouldPostFailedCallbackIfNoData() {
        // Given
        let session = FakeURLSession(data: nil, response: nil, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.translate(from: .en, to: .fr, text: "How are you ?") { (success, result) -> Void in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testTranslationServiceShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.correctTranslationData, response: FakeResponseData.responseKO, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.translate(from: .en, to: .fr, text: "How are you ?") { (success, result) -> Void in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testTranslationServiceShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.translate(from: .en, to: .fr, text: "How are you ?") { (success, result) -> Void in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testTranslationServiceShouldPostFailedCallbackIfError() {
        // Given
        let session = FakeURLSession(data: nil, response: nil, error: FakeResponseData.error)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.translate(from: .en, to: .fr, text: "How are you ?") { (success, result) -> Void in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }

    func testTranslationServiceShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let session = FakeURLSession(data: FakeResponseData.correctTranslationData, response: FakeResponseData.responseOK, error: nil)
        let service = TranslateService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // When
        service.translate(from: .en, to: .fr, text: "How are you ?") { (success, result) -> Void in
            // Then
            XCTAssertEqual("Comment allez-vous ?", result?.data.translations[0].translatedText)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
}
