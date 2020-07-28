//
//  Translations.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol TranslationDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

class Translater {

    enum Mode {
        case enToFr, frToEn
    }

    enum Language: String {
        case en = "en", fr = "fr"
    }

    enum TranslationError: Error {
        case textToTranslateNil
        case destinationLanguageNil
        case originLanguageNil
        case translationImpossible
    }

    weak var displayDelegate: TranslationDelegate?
//    var text: String?
//    var to: Language?
    var status: String?
    private(set) var errorMessage: String? {
        didSet { displayDelegate?.displayError(errorMessage!) }
    }
    private(set) var resultMessage: String? {
        didSet { displayDelegate?.displayResult(resultMessage!) }
    }

//    init(text: String?, to: Language) {
//        self.text = text
//        self.to = to
//    }

    func translate(text: String?, to: Language?) throws {
        guard let to = to else {
            errorMessage = "There is no information on the language of origin or destination."
            throw TranslationError.destinationLanguageNil
        }

        guard let text = text, text != "" else {
            errorMessage = "First enter a text to be translated."
            throw TranslationError.textToTranslateNil
        }
        var from: Language {
            if to == .en {
                return .fr
            } else {
                return .en
            }
        }

        displayDelegate?.displayActivity(true)
        let translationService = TranslateService.shared

        translationService.translate(from: from, to: to, text: text) { (success, result) -> Void in
            guard success, let result = result else {
                self.errorMessage = "le texte n'a pas pu être traduit"
                return // To Thows !!!!
            }
            self.displayDelegate?.displayActivity(false)
            self.resultMessage = result.data.translations[0].translatedText
            return
        }
        throw TranslationError.translationImpossible
    }

 }

struct ResultTranslation: Codable {
    struct DataResult: Codable {
        struct Translation: Codable {
            var translatedText: String
        }
        let translations: [Translation]
    }
    let data: DataResult
}
