//
//  TranslateService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class TranslateService {
    private let apiKey = valueForAPIKey(named:"ApiGoogleTtranslate")
    let baseURL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    let text = "Hello world, My name is Ludovic"
    
    func translateText(callback: @escaping (Bool, ResultTranslation?) -> (Void)) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "key=\(apiKey)&q=\(text)&target=fr&source=en&source&format=text".data(using: .utf8)
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
