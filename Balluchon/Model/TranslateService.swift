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
    private let baseURL = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    static var shared = TranslateService()
    private init() {}
    init(session: URLSession) {
        self.session = session
    }
    func translate(from: Language, to: Language, text: String, callback: @escaping (Bool, ResultTranslation?) -> (Void)) {
        task?.cancel()
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "key=\(apiKey)&source=\(from.rawValue)&q=\(text)&target=\(to.rawValue)&\(from)&source&format=text".data(using: .utf8)
        task = session.dataTask(with: request) { (data, response, error) in
            
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
        task?.resume()
    }
    

}
