//
//  Translations.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation


struct ResultTranslation: Codable {
    struct DataResult: Codable {

        struct Translation: Codable {
            var translatedText: String
            var detectedSourceLanguage: String
        }
        let translations: [Translation]
        
    }
    
    let data: DataResult
}





