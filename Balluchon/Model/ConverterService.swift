//
//  CurrencyService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

/// This class is a singleton. It gets the money rates from the API of "fix.io".
class ConverterService {
    // --- API KEY ---
    private let apiKey = valueForAPIKey(named: "ApiFixer")
    // --- --- --- ---
    private let baseURL = "http://data.fixer.io/api/latest"
    private var session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?

    /// This property sets the value ...
    static var shared = ConverterService()

    private init() {}

    /// Dependency injection
    /// - Parameter session: You can inject a fake URLSession for unit tests.
    init(session: URLSession) {
        self.session = session
    }

    /// This method will download to "fix.io" the most recent value of the monetary rates.
    /// At the end of the task, it runs a closure which will have to process a "Currency" if it's a success.
    /// - Parameters:
    ///     - callback: The closure called after retrieval.
    ///     - succes: Returns "true" if the retrive is a succes.
    ///     - result: The retrieved "Currency".
    func getCurrency(callback: @escaping(_ succes: Bool, _ result: Currency?) -> Void) {
        let urlRequest = URL(string: "\(baseURL)?access_key=\(apiKey)")!
        task?.cancel()
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
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
