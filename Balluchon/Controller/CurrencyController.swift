//
//  CurrencyViewModel.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 16/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol CurrencyDisplayDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

class CurrencyController {
    
    weak var displayDelegate: CurrencyDisplayDelegate?
    private var rate: Double?
        
    func fechingData() {
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
    
    private(set) var errorMessage: String? {
        didSet {
            displayDelegate?.displayError(errorMessage!)
        }
    }
    
    private(set) var resultMessage: String? {
        didSet {
            displayDelegate?.displayResult(resultMessage!)
        }
    }
            
    
    func convertValue(mode: CurrencyMode?, value: String?) {
        
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
