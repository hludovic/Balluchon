//
//  CurrencyControllerTestCase.swift
//  BalluchonTests
//
//  Created by Ludovic HENRY on 17/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import XCTest
@testable import Balluchon

class CurrencyControllerTestCase: XCTestCase {
    var currencyController: CurrencyController!
    var tc: TranslationController!
    
    override func setUp() {
        super.setUp()
        currencyController = CurrencyController()
        currencyController.fechingData()
    }
    
    func testUntruc() {
        print("----------------")
        print(currencyController.errorMessage!)
    }
    
}
