//
//  Translations.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol TranslaterDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

class Translater {
    weak var displayDelegate: TranslaterDelegate?
    enum Language: String {
        case en = "en", fr = "fr"
    }
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    private(set) var resultMessage: String? {
        didSet { displayDelegate?.displayResult(resultMessage!) }
    }
        
    func translate(text: String?, to: Language?) throws {
        guard let to = to else {
            errorMessage = "There is no information on the language of origin or destination."
            return
        }
        guard let text = text, text != "" else {
            errorMessage = "First enter a text to be translated."
            return
        }
        
        var from: Language {
            return to == .en ? .fr : .en
        }
        
        displayDelegate?.displayActivity(true)
        TranslateService.shared.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                self.errorMessage = "le texte n'a pas pu être traduit"
                self.displayDelegate?.displayActivity(false)
                return
            }
            self.displayDelegate?.displayActivity(false)
            self.resultMessage = result.data.translations[0].translatedText
        }
    }
 }

struct TranslationResult: Codable {
    struct DataResult: Codable {
        struct Translation: Codable {
            var translatedText: String
        }
        let translations: [Translation]
    }
    let data: DataResult
}
