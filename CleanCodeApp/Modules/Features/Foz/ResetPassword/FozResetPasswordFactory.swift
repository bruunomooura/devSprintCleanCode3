//
//  FozResetPasswordFactory.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import UIKit

enum FozResetPasswordFactory{

    static func make() -> UIViewController {
        let storyboard = UIStoryboard(name: "FozUser", bundle: nil)

        let resetPasswordService = ResetPasswordService()
        let emailValidator = EmailValidatorUseCase()
        let viewModel = FozResetPasswordViewModel(
            resetPasswordService: resetPasswordService,
            emailValidator: emailValidator
        )

        let coordinator = FozResetPasswordCoordinator()

        let viewController = storyboard.instantiateViewController(
            identifier: "FozResetPasswordViewController",
            creator: { coder in
                FozResetPasswordViewController(
                    coder: coder,
                    viewModel: viewModel,
                    coordinator: coordinator
                )
            }
        )


        coordinator.viewController = viewController

        return viewController
    }
}


