//
//  ResetPasswordError.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 18/02/25.
//


enum ResetPasswordError: Error {
    case noInternet
    case custom(String)

    var localizedDescription: String {
        switch self {
        case .noInternet:
            return "Sem conexão com a internet"
        case .custom(let message):
            return message
        }
    }
}