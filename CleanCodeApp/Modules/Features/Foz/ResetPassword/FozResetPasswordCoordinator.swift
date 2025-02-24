//
//  FozResetPasswordCoordinator.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import UIKit
import Foundation

final class FozResetPasswordCoordinator: FozResetPasswordCoordinating {
    weak var viewController: UIViewController?

    func showContactUs() {
        let contactUsVC = FozResetPasswordFactory.make()
        contactUsVC.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.pushViewController(contactUsVC, animated: true)
    }

    func showCreateAccount() {
        let createAccountVC = FozResetPasswordFactory.make()
        createAccountVC.modalPresentationStyle = .fullScreen
        viewController?.navigationController?.pushViewController(createAccountVC, animated: true)
    }
}
