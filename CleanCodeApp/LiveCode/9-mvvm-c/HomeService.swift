//
//  HomeService.swift
//  CleanCode
//
//  Created by Pedro Menezes on 21/02/25.
//

import Foundation

protocol CurrencyServiceProtocol {
    func fetchConversionRate(from origin: String, to destiny: String) async throws -> Double
}

class CurrencyService: CurrencyServiceProtocol {
    func fetchConversionRate(from origin: String, to destiny: String) async throws -> Double {
        let urlString = ApiEndpoints.createFetchConversionRate(from: origin, to: destiny)
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        if let dataMap = jsonObject?["data"] as? [String: Any],
           let currencyInfo = dataMap[origin] as? [String: Any],
           let value = currencyInfo["value"] as? Double {
            return value
        } else {
            throw NSError(domain: "Data parsing error", code: 500, userInfo: nil)
        }
    }
}
