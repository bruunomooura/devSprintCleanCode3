//
//  ResetPasswordViewModelProtocol.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//
import UIKit

protocol FozResetPasswordManaging: AnyObject {
    func isEmailValid(_ email: String?) -> Bool
    func performPasswordReset(from presenter: UIViewController,
                              withEmail email: String?) async throws -> String
}
