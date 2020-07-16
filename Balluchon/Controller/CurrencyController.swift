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
    private var currencyService: CurrencyService?
    private var rate: Double?
    
    var activity: Bool = false {
        didSet {
            displayDelegate?.displayActivity(activity)
        }
    }
    
    var resultDisplay: String? {
        didSet {
            displayDelegate?.displayResult(resultDisplay!)
        }
    }
    
    var errorDisplay: String? {
        didSet {
            displayDelegate?.displayError(errorDisplay!)
        }
    }
    
    func fechingData() {
        activity = true
        CurrencyService.shared.getCurrency { (success, currency) -> (Void) in
            guard success, let currency = currency else {
                self.errorDisplay = "ERROR"
                return
            }
            
            self.rate = currency.rates.USD
            self.activity = false
        }
    }
            
    
    func convertValue(mode: CurrencyMode, value: String) {
        
        guard let value = Double(value) else {
            errorDisplay = "ERROR"
            return
        }
        
        guard let rate = rate else {
            errorDisplay = "ERROR"
            return
        }
        
        switch mode {
        case .dolToEur:
            resultDisplay = "\(rate * value) €"
        case .eurToDol:
            resultDisplay = "\(value / rate) $"
        }
        
        
        
    }
    
}
