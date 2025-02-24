//
//  RumContactUsError.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 15/02/25.
//

import Foundation

enum RumContactUsError: Error {
    case networkError
    case decodingError
    
    var logMessage: String {
        switch self {
        case .networkError:
            return "Network error: unable to reach the server."
        case .decodingError:
            return "Decoding error: failed to parse the response data."
        }
    }
}
