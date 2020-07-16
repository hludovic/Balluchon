//
//  TranslationController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 16/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

protocol TranslationDisplayDelegate: AnyObject {
    func displayResult(_ text: String)
    func displayError(_ text: String)
    func displayActivity(_ activity: Bool)
}

class TranslationController {
    
    weak var displayDelegate: TranslationDisplayDelegate?
    let translationService = TranslateService.shared
    
    func translateText(from: Language, to: Language, text: String) {
        displayDelegate?.displayActivity(true)
        translationService.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                self.displayDelegate?.displayError("ERROR")
                return
            }
            self.displayDelegate?.displayActivity(false)
            self.displayDelegate?.displayResult(result.data.translations[0].translatedText)
        }
    }
    
}
