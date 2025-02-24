//
//  CeuResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 10/02/25.
//

import UIKit

protocol CeuResetPasswordCoordinatorProtocol {
    var viewController: CeuResetPasswordViewController? { get set }
    func showContactUsViewController()
    func showCreateAccountViewController()
    func showAlert()
    func showAlertWith(message: String)
    func showNoInternetConnectionAlert()
}


class CeuResetPasswordCoordinator: CeuResetPasswordCoordinatorProtocol, CeuGlobalsProtocol {
    weak var viewController: CeuResetPasswordViewController?

    func showContactUsViewController() {
        let ceuContactUsViewController = CeuContactUsViewController()
        ceuContactUsViewController.modalPresentationStyle = .fullScreen
        ceuContactUsViewController.modalTransitionStyle = .coverVertical
        self.viewController?.present(ceuContactUsViewController, animated: true, completion: nil)
    }

    func showCreateAccountViewController() {
        let ceuCreateAccountViewController = CeuCreateAccountViewController()
        ceuCreateAccountViewController.modalPresentationStyle = .fullScreen
        Task { @MainActor in
            self.viewController?.present(ceuCreateAccountViewController, animated: true)
        }
    }

    func showAlert() {
        let alertController = UIAlertController(title: CeuResetPasswordStrings.ops.localized(), message: CeuResetPasswordStrings.somethingWentWrongErrorMessage.localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: CeuResetPasswordStrings.ok.localized(), style: .default)
        alertController.addAction(action)
        Task { @MainActor in
            self.viewController?.present(alertController, animated: true)
        }
    }

    func showAlertWith(message: String) {
        guard let viewController = viewController else { return }
        return self.alertMessage(title: CeuResetPasswordStrings.ops.localized(), message: message, targetVC: viewController, action: nil)
    }

    func showNoInternetConnectionAlert() {
        guard let viewController = viewController else { return }
        self.showNoInternetCOnnection(controller: viewController)
    }
}
