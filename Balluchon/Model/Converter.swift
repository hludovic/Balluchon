//
//  Currency.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol ConverterDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

class Converter {
    weak var displayDelegate: ConverterDelegate?
    private var rate: Double?
    enum Mode {
        case eurToDol, dolToEur
    }
    
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    
    private(set) var resultMessage: String? {
        didSet { displayDelegate?.displayResult(resultMessage!) }
    }

    func fetchData() {
        displayDelegate?.displayActivity(true)
        CurrencyService.shared.getCurrency { (success, currency) -> (Void) in
            guard success, let currency = currency else {
                self.displayDelegate?.displayError("The data could not be downloaded")
                return
            }
            self.rate = currency.rates.USD
            self.displayDelegate?.displayActivity(false)
        }
    }
    
    func convertValue(mode: Converter.Mode?, value: String?) {
        
        guard let mode = mode else {
            errorMessage = "The mode of translation has not been indicated."
            return
        }
        
        guard let value = value else {
            errorMessage = "We haven't received the number to convert."
            return
        }
        
        guard let valueDouble = Double(value) else {
            errorMessage = "You didn't enter a number"
            return
        }
        
        guard let rate = rate else {
            errorMessage = "The rate could not be found"
            return
        }
        
        switch mode {
        case .dolToEur:
            resultMessage = "\(formatResult(valueDouble / rate)) €"
        case .eurToDol:
            resultMessage = "\(formatResult(rate * valueDouble)) $"
        }
    }
    
    /// This method roun a Double value to 3 number of decimal places, and returns the result as String.
    /// - Parameter result: The Double property that needs to be rounded.
    private func formatResult(_ result: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 3
        if let numberFormatted = numberFormatter.string(from: NSNumber(value: result)) {
            return numberFormatted
        } else { return "" }
    }
    
}

struct Currency: Codable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    struct Rates: Codable {
        var USD: Double
    }
    var rates: Rates
}
