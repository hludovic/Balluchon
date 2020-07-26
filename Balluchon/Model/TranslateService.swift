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
    
    /// This property is the only "TranslateService" session available.
    static var shared = TranslateService()
    
    private init() {}
    
    /// Dependency injection
    /// - Parameter session: You can inject a fake URLSession for unit tests.
    init(session: URLSession) {
        self.session = session
    }
    
    /// The method will translate text with a google api.
    /// - Parameters:
    ///   - from: The language of the original text
    ///   - to: The language into which the text is to be translated
    ///   - text: The text to be translated
    ///   - callback: The closure called after retrieval.
    ///   - success: Returns "true" if the retrive is a succes.
    ///   - result: The retrieved "Translation".
    func translate(from: Translater.Language, to: Translater.Language, text: String,
                   callback: @escaping (_ success: Bool, _ result: Translation?) -> (Void)) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "key=\(apiKey)&source=\(from.rawValue)&q=\(text)&target=\(to.rawValue)&\(from)&source&format=text".data(using: .utf8)
        task?.cancel()
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
                guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
