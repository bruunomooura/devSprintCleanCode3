//
//  CeuResetPasswordViewModel.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//
import UIKit

protocol CeuResetPasswordViewModelDelegate: AnyObject {
    func handleResetPasswordRequestSuccess()
    func handleResetPasswordRequestError()
    func validateForm() throws
    func showAlertWith(message: String)
    func showNoInternetConnectionAlert()
}

protocol CeuResetPasswordViewModelProtocol {
    var delegate: CeuResetPasswordViewModelDelegate? { get set }
    func startRecoverPasswordWith(email: String?)
}

class CeuResetPasswordViewModel: CeuResetPasswordViewModelProtocol {
    weak var delegate: CeuResetPasswordViewModelDelegate?
    private let resetPasswordService: CeuResetPasswordServiceProtocol
    private let connectivityManager: ConnectivityManagerProxy

    init(
        resetPasswordService: CeuResetPasswordServiceProtocol,
        connectivityManager: ConnectivityManagerProxy = ConnectivityManager.shared
    ) {
        self.resetPasswordService = resetPasswordService
        self.connectivityManager = connectivityManager
    }

    func startRecoverPasswordWith(email: String?) {
        do {
            try delegate?.validateForm()
            try verifyInternetConnection()

            makeResetPasswordRequest(email: email)
        } catch CeuCommonsErrors.invalidEmail {
            delegate?.showAlertWith(message: CeuResetPasswordStrings.verifyEmailErrorMessage.localized())
        } catch {
            delegate?.showAlertWith(message: CeuResetPasswordStrings.somethingWentWrongErrorMessage.localized())
        }
    }
}

private extension CeuResetPasswordViewModel {

    func verifyInternetConnection() throws {
        if !connectivityManager.isConnected {
            delegate?.showNoInternetConnectionAlert()
            throw CeuCommonsErrors.networkError
        }
    }

    func makeResetPasswordRequest(email: String?) {
        Task { @MainActor in
            do {
                _ = try await resetPasswordService.resetPassword(email: email)
                delegate?.handleResetPasswordRequestSuccess()
            } catch {
                delegate?.handleResetPasswordRequestError()
            }
        }
    }
}
