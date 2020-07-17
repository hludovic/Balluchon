//
//  CurrencyService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class CurrencyService {
    // --- API KEY ---
    private let apiKey = valueForAPIKey(named:"ApiFixer")
    // --- --- --- ---
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private init() {}
    static var shared = CurrencyService()
    init(session: URLSession) {
        self.session = session
    }
    
    func getCurrency(callback: @escaping(Bool, Currency?) -> (Void)) {
        let baseURL = URL(string: "http://data.fixer.io/api/latest?access_key=\(apiKey)")!
        task?.cancel()
        task = session.dataTask(with: baseURL, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
        })
        
        task?.resume()
    }
}
