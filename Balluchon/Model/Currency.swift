//
//  Currency.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

enum CurrencyMode {
    case eurToDol, dolToEur
}

struct Currency: Codable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: Rates
}

struct Rates: Codable {
    var USD: Double
}
