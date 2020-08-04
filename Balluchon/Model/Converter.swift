//
//  Currency.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

/// Any class complying with this protocol will be delegated the tasks of displaying the result, error messages and activity indication.
protocol ConverterDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

/// This class tests and performs convertions, and delegates the display of its results.
class Converter {
    weak var displayDelegate: ConverterDelegate?

    /// Lists all kind of convertions that can be performed with a Converter.
    enum Mode { case eurToDol, dolToEur }

    private var currency: Currency?

    /// Dependency injection
    /// - Parameter currency: You can inject a "Currency" for unit tests.
    convenience init(currency: Currency) {
        self.init()
        self.currency = currency
    }

    /// This property sets the value of the error message that should be displayed.
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }

    /// This property sets the value of the result message that should be displayed.
    private(set) var resultMessage: String? {
        didSet { displayDelegate?.displayResult(resultMessage!) }
    }

    /// This property may or may not indicate loading activity.
    private(set) var isLoading: Bool? {
        didSet { displayDelegate?.displayActivity(isLoading!) }
    }

    /// This function retrieves the value of the currencies and displays an animation during this operation.
    /// - Parameter completion: The closure called after retrieval.
    /// - Parameter success: Returns "true" if the retrive is a succes.
    func fetchData(completion: @escaping (_ success: Bool) -> Void) {
        isLoading = true
        ConverterService.shared.getCurrency { (success, currency) -> Void in
            guard success, let currency = currency else {
                self.errorMessage = "The data could not be downloaded"
                self.isLoading = false
                completion(false)
                return
            }
            self.currency = currency
            self.isLoading = false
            completion(true)
        }
    }

    /// This method translates currencies
    /// - Parameters:
    ///   - mode: It defines in which currency the value will have to be converted into.
    ///   - value: The value to be converted.
    func convertValue(mode: Converter.Mode?, value: String?) {
        guard let currency = currency else {
            errorMessage = "The currency is not downloaded."
            return
        }
        guard let mode = mode else {
            errorMessage = "The mode of translation has not been indicated."
            return
        }
        guard let value = value else {
            errorMessage = "We haven't received the number to convert."
            return
        }
        guard let valueFloat = Float(value) else {
            errorMessage = "You didn't enter a number"
            return
        }
        switch mode {
        case .dolToEur:
            resultMessage = String(format: "%.2f €", (valueFloat / currency.rates["USD"]!))
        case .eurToDol:
            resultMessage = String(format: "%.2f $", (currency.rates["USD"]! * valueFloat))
        }
    }
}

/// The structure of the currency data received.
struct Currency: Codable {
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    let rates: [String: Float]
}
