//
//  Translations.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

enum TranslateMode {
    case enToFr, frToEn
}

enum Language: String {
    case en = "en", fr = "fr"
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



