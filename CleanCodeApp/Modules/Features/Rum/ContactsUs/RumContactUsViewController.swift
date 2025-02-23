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
    private let contactUsService = RumContactUsAPIService()
    
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
        contactUsView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func didTapPhoneButton() {
        guard let tel = model?.phone, let url = URL(string: "tel://\(tel)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func didTapEmailButton() {
        guard let mail = model?.mail, let url = URL(string: "mailto:\(mail)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func didTapChatButton() {
        guard let phoneNumber = model?.phone, let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi)") else { return }
        UIApplication.shared.canOpenURL(whatsappURL) ? openWhatsapp(whatsappURL) : openAppStore()
    }
    
    private func openWhatsapp(_ whatsappURL: URL) {
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
    
    private func openAppStore() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    func fetchData() {
        showLoadingView()
        Task {
            let result = await contactUsService.fetchContactUsData()
            handleFetchResult(result)
        }
    }

    private func handleFetchResult(_ result: Result<ContactUsModel, RumContactUsError>) {
        removeLoadingView()
        switch result {
        case .success(let model):
            self.model = model
        case .failure(let error):
            print("Log error: \(error.logMessage)")
            handleAlertMessage(title: "Ops..", message: "Ocorreu algum erro", shouldDismiss: true)
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
            let result = await contactUsService.sendMessage(parameters: parameters)
            handleSendMessageResult(result)
        }
    }
    
    private func handleSendMessageResult(_ result: Result<Void, RumContactUsError>) {
        removeLoadingView()
        switch result {
        case .success:
            handleAlertMessage(title: "Sucesso..", message: "Sua mensagem foi enviada", shouldDismiss: true)
        case .failure(let error):
            print("Log error: \(error.logMessage)")
            handleAlertMessage(title: "Ops..", message: "Ocorreu algum erro")
        }
    }
    
    private func handleAlertMessage(title: String, message: String, shouldDismiss: Bool = false) {
        Globals.showAlertMessage(title: title, message: message, targetVC: self) {
            shouldDismiss ? self.dismiss(animated: true) : nil
        }
    }
}
