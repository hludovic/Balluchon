//
//  CurrencyService.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import Foundation

class CurrencyService {
    private let baseURL = URL(string: "https://api.exchangeratesapi.io/latest")!
    private let session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    
    static var shared = CurrencyService()
    private init() {}
    
    func getCurrency(callback: @escaping(Bool, Currency?) -> (Void)) {
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
