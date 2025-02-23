//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

class MelContactUsViewController: UIViewController {
    private var viewModel: MelContactUsViewModelProtocol
    private var contactUsView: MelContactUsView?
    private let melLoadingView: MelLoadingViewProtocol
    private let melAlertDisplay: MelAlertDisplayProtocol
    
    init(viewModel: MelContactUsViewModelProtocol,
         melLoadingView: MelLoadingViewProtocol,
         melAlertDisplay: MelAlertDisplayProtocol) {
        self.viewModel = viewModel
        self.melLoadingView = melLoadingView
        self.melAlertDisplay = melAlertDisplay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactUsView?.setDelegate(delegate: self)
        viewModel.setDelegate(delegate: self)
        viewModel.fetchAndProcessContactData()
    }
    
    override func loadView() {
        self.contactUsView = MelContactUsView()
        view = contactUsView
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

// MARK: - Functions
extension MelContactUsViewController: MelContactUsViewDelegate {
    func didTapPhoneCallButton() {
        viewModel.openPhoneForCall()
    }
    
    func didTapEmailButton() {
        viewModel.openEmailForMessage()
    }
    
    func didTapChatButton() {
        viewModel.openWhatsAppOrRedirect()
    }
    
    func didTapSendMessageButton(message: String) {
        Task {
            await viewModel.sendMessageToSupport(message: message)
        }
    }
    
    func didTapCloseButton() {
        dismiss(animated: true)
    }
}

extension MelContactUsViewController: MelContactUsViewModelDelegate {
    func presentLoading() {
        melLoadingView.showLoadingView(on: self.view)
    }
    func hideLoading() {
        melLoadingView.hideLoadingView()
    }
    
    func presentErrorAlert(mustDismiss: Bool) {
        melAlertDisplay.displayErrorAlert(on: self, mustDismiss: mustDismiss)
    }
    
    func presentSuccessAlert() {
        melAlertDisplay.displayErrorAlert(on: self, mustDismiss: true)
    }
}

enum ChatError: Error {
    case invalidPhoneNumber
    case invalidURL
}
