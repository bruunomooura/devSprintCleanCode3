//
//  FozResetPasswordVM.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//



import Foundation
import UIKit

class FozResetPasswordViewModel: FozResetPasswordManaging {

    private let resetPasswordService: FozResetPasswordServicing
    private let emailValidator: EmailValidating

    init(resetPasswordService: FozResetPasswordServicing,
         emailValidator: EmailValidating) {
        self.resetPasswordService = resetPasswordService
        self.emailValidator = emailValidator
    }

    func isEmailValid(_ email: String?) -> Bool {
        return emailValidator.isValid(email)
    }


    func performPasswordReset(from presenter: UIViewController,
                              withEmail email: String?) async throws -> String {

        guard let email = email?.trimmingCharacters(in: .whitespaces),
              !email.isEmpty else {
            throw ResetPasswordError.custom("E-mail inválido")
        }

        return try await withCheckedThrowingContinuation { continuation in
            resetPasswordService.performPasswordReset(
                from: presenter,
                with: ["email": email]
            ) { success in
                if success {
                    continuation.resume(returning: email)
                } else {
                    continuation.resume(
                        throwing: ResetPasswordError.custom("Falha ao resetar a senha.")
                    )
                }
            }
        }
    }
}


