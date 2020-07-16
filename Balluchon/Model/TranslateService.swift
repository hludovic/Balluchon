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
    let session = URLSession(configuration: .default)
    
    static var shared = TranslateService()
    private init() {}
    
//    let text = "Hello world, My name is Ludovic"
    
    func translate(from: String, to: String, text: String, callback: @escaping (Bool, ResultTranslation?) -> (Void)) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "key=\(apiKey)&source=\(from)&q=\(text)&target=\(to)&\(from)&source&format=text".data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("1")
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("2")
                    callback(false, nil)
                    return
                }
                                
                guard let responseJSON = try? JSONDecoder().decode(ResultTranslation.self, from: data) else {
                    print("3")
                    callback(false, nil)
                    return
                }
                print("key=\(self.apiKey)&q=\(text)&target=\(to)&source=\(from)&source&format=text")
                print(responseJSON.data.translations[0].translatedText)
                callback(true, responseJSON)
            }
            
            
        }
        task.resume()
    }
    

}
