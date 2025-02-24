//
//  ResetPasswordService.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//
import Foundation
import UIKit


// TODO: Puxar Tarefa 6, farei isso num outro commit
class ResetPasswordService: FozResetPasswordServicing {

    func performPasswordReset(from presenter: UIViewController,
                             with parameters: [String: String],
                             completion: @escaping (Bool) -> Void) {

        BadNetworkLayer.shared.resetPassword(
            presenter,
            parameters: parameters,
            completionHandler: completion
        )
    }
}

