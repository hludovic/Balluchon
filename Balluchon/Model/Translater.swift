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
    
    private(set) var resultMessage: Translation? {
        didSet { displayDelegate?.displayResult(resultMessage!.data.translations[0].translatedText) }
    }
    
    func translate(text: String?, to: Language?, completion: @escaping (Bool) -> (Void)) {
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
        displayDelegate?.displayActivity(true)
        TranslateService.shared.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                self.errorMessage = "The text could not be translated."
                self.displayDelegate?.displayActivity(false)
                completion(false)
                return
            }
            self.displayDelegate?.displayActivity(false)
            self.resultMessage = result
            completion(true)
        }
    }
 }

struct Translation: Codable {
    struct DataResult: Codable {
        struct Translation: Codable {
            var translatedText: String
        }
        let translations: [Translation]
    }
    let data: DataResult
}
