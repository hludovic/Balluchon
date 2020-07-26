//
//  Translations.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

/// Any class complying with this protocol will be delegated the tasks of displaying the result, error messages and activity indication.
protocol TranslaterDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

/// This class tests and performs translations, and delegates the display of its results.
class Translater {
    weak var displayDelegate: TranslaterDelegate?    
    
    /// Lists all kind of translations languages that can be performed with a Translater.
    enum Language: String { case en = "en", fr = "fr" }
    
    /// This property sets the value of the error message that should be displayed.
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    
    /// This property sets the value of the result message that should be displayed.
    private(set) var resultMessage: Translation? {
        didSet { displayDelegate?.displayResult(resultMessage!.data.translations[0].translatedText) }
    }
    
    /// This property may or may not indicate loading activity.
    private(set) var isLoading: Bool? {
        didSet { displayDelegate?.displayActivity(isLoading!) }
    }
    
    /// This method translates text and displays an animation during this operation.
    /// - Parameters:
    ///   - text: The text to be translated.
    ///   - to: the target language.
    ///   - completion: The closure called after retrieval.
    ///   - success: Returns "true" if the translation is a succes.
    func translate(text: String?, to: Language?, completion: @escaping (_ success: Bool) -> (Void)) {
        guard let to = to else {
            errorMessage = "There is no information on the language of origin or destination."
            completion(false)
            return
        }
        guard let text = text, text != "" else {
            errorMessage = "First enter a text to be translated."
            completion(false)
            return
        }
        var from: Language {
            return to == .en ? .fr : .en
        }
        isLoading = true
        TranslateService.shared.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                self.errorMessage = "The text could not be translated."
                self.isLoading =  false
                completion(false)
                return
            }
            self.isLoading = false
            self.resultMessage = result
            completion(true)
        }
    }
 }

/// The structure of the translation data received.
struct Translation: Codable {
    struct DataResult: Codable {
        struct Translation: Codable {
            var translatedText: String
        }
        let translations: [Translation]
    }
    let data: DataResult
}
