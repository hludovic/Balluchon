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
    
    func translateText(from: Language?, to: Language?, text: String?) {
        guard let from = from, let to = to else {
            errorMessage = "There is no information on the language of origin or destination."
            return
        }
        
        guard from != to else {
            errorMessage = "The language of origin and destination are the same."
            return
        }
        
        guard let text = text, text != "" else {
            errorMessage = "First enter a text to be translated."
            return
        }
        
        displayDelegate?.displayActivity(true)
        translationService.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                self.errorMessage = "The text could not be translated."
                return
            }
            self.displayDelegate?.displayActivity(false)
            self.resultMessage =  result.data.translations[0].translatedText
        }
    }
    
}
