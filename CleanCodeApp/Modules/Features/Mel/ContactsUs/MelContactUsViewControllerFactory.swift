//
//  MelContactUsViewControllerFactory.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 23/02/25.
//

import UIKit

enum MelContactUsViewControllerFactory {
    static func make() -> MelContactUsViewController {
        let appOpener: ExternalAppOpening = ExternalAppOpener(
            application: UIApplication.shared
        )
        let contactUsService: MelContactUsServiceProtocol = MelContactUsService(
            networking: MelNetworkManager()
        )
        let viewModel: MelContactUsViewModelProtocol = MelContactUsViewModel(
            appOpener: appOpener,
            contactUsService: contactUsService
        )
        let melLoadingView: MelLoadingViewProtocol = MelLoadingView()
        
        return MelContactUsViewController(
            viewModel: viewModel,
            melLoadingView: melLoadingView
        )
    }
}
