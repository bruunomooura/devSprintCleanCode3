//
//  ContactUsViewController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 17/07/22.
//

import UIKit

final class RumContactUsViewController: LoadingInheritageController {
    // MARK: - Model
    var model: ContactUsModel?
    
    // MARK: - UI Components
    private lazy var contactUsView = RumContactUsView()
    
    // MARK: - Services
    private let contactUsService: RumContactAPIServicing
    private let externalAppLinkService: RumExternalAppLinkServicing
    
    init(service: RumContactAPIServicing,
         externalAppLinkService: RumExternalAppLinkServicing = RumExternalAppLinkService()) {
        self.contactUsService = service
        self.externalAppLinkService = externalAppLinkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contactUsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        fetchData()
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        contactUsView.phoneButton.addTarget(self, action: #selector(didTapPhoneButton), for: .touchUpInside)
        contactUsView.emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        contactUsView.chatButton.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        contactUsView.sendMessageButton.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        contactUsView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    func fetchData() {
        showLoadingView()
        Task {
            self.model = await contactUsService.fetchContactUsData()
            removeLoadingView()
        }
    }
    
    @objc func didTapSendMessageButton() {
        view.endEditing(true)
        let email = model?.mail ?? ""
        if let message = contactUsView.textView.text, contactUsView.textView.text.count > 0 {
            let parameters: [String: String] = [
                "email": email,
                "mensagem": message
            ]
            sendMessage(parameters: parameters)
        }
    }
    
    private func sendMessage(parameters: [String: String]) {
        showLoadingView()
        Task {
            await contactUsService.sendMessage(parameters: parameters)
            removeLoadingView()
        }
    }
}

// MARK: - Button Actions
private extension RumContactUsViewController {
    @objc func didTapPhoneButton() {
        guard let phoneNumber = model?.phone else { return }
        externalAppLinkService.openExternalAppLink(.phone(phoneNumber))
    }
    
    @objc func didTapEmailButton() {
        guard let mail = model?.mail else { return }
        externalAppLinkService.openExternalAppLink(.email(mail))
    }
    
    @objc func didTapChatButton() {
        guard let phoneNumber = model?.phone else { return }
        externalAppLinkService.openExternalAppLink(.whatsapp(phoneNumber))
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
}

extension RumContactUsViewController: RumContactUsAPIServiceDelegate {
    func showAlertMessage(title: String, message: String, shouldDismiss: Bool = false) {
        Globals.showAlertMessage(title: title, message: message, targetVC: self) {
            shouldDismiss ? self.dismiss(animated: true) : nil
        }
    }
}
