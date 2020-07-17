//
//  FakeResponseData.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class FakeResponseData {

    static var correctCurrencyData: Data? {
        let bundle = Bundle.init(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var correctTranslationData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static var incorectData = "ErrorData".data(using: .utf8)

    static var responseOK = HTTPURLResponse(url: URL(string: "https://google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static var responseKO = HTTPURLResponse(url: URL(string: "https://google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)

    class FakeEror: Error {}
    static let error = FakeEror()
}
