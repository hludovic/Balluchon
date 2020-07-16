//
//  TranslateService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class TranslateService {
    // --- API KEY ---
    private let apiKey = valueForAPIKey(named:"ApiGoogleTtranslate")
    // --- --- --- ---
    let baseURL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    let session = URLSession(configuration: .default)
    
    static var shared = TranslateService()
    private init() {}
        
    func translate(from: Language, to: Language, text: String, callback: @escaping (Bool, ResultTranslation?) -> (Void)) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "key=\(apiKey)&source=\(from.rawValue)&q=\(text)&target=\(to.rawValue)&\(from)&source&format=text".data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                                
                guard let responseJSON = try? JSONDecoder().decode(ResultTranslation.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
            
            
        }
        task.resume()
    }
    

}
