//
//  RumContactUsView.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import UIKit

final class RumContactUsView: UIView {
    // MARK: - UI Components
    
    private lazy var headerStackView: UIStackView = {
        let headerStackView = UIStackView()
        headerStackView.axis = .vertical
        headerStackView.spacing = 30
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerStackView
    }()
    
    private lazy var headerButtonsStackView: UIStackView = {
        let headerButtonsStackView = UIStackView()
        headerButtonsStackView.axis = .horizontal
        headerButtonsStackView.distribution = .equalCentering
        headerButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return headerButtonsStackView
    }()
    
    private lazy var screenTitle: UILabel = {
        let screenTitle = UILabel()
        screenTitle.textColor = .black
        screenTitle.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        screenTitle.text = "Escolha o canal para contato"
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        return screenTitle
    }()
    
    lazy var phoneButton: UIButton = {
        let phoneButton = UIButton()
        phoneButton.backgroundColor = .systemGray4
        phoneButton.layer.cornerRadius = 10
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        return phoneButton
    }()
    
    lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.backgroundColor = .systemGray4
        emailButton.layer.cornerRadius = 10
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        return emailButton
    }()
    
    lazy var chatButton: UIButton = {
        let chatButton = UIButton()
        chatButton.backgroundColor = .systemGray4
        chatButton.layer.cornerRadius = 10
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        return chatButton
    }()
    
    private lazy var centerStackView: UIStackView = {
        let centerStackView = UIStackView()
        centerStackView.axis = .vertical
        centerStackView.spacing = 20
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        return centerStackView
    }()
    
    private lazy var textViewTitle: UILabel = {
        let textViewTitle = UILabel()
        textViewTitle.textColor = .black
        textViewTitle.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textViewTitle.text = "Ou envie uma mensagem"
        textViewTitle.numberOfLines = 2
        textViewTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textViewTitle.translatesAutoresizingMaskIntoConstraints = false
        return textViewTitle
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Escreva sua mensagem aqui"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let bottomStackView = UIStackView()
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 20
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        return bottomStackView
    }()
    
    lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.backgroundColor = .blue
        sendMessageButton.setTitle("  Enviar ", for: .normal)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.setContentHuggingPriority(.required, for: .horizontal)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        return sendMessageButton
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("Voltar", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.backgroundColor = .clear
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.blue.cgColor
        backButton.layer.cornerRadius = 10
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .systemGray6
        setupButtonImages()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupButtonImages() {
        phoneButton.setSymbolImage(systemName: "phone", pointSize: 36)
        emailButton.setSymbolImage(systemName: "envelope", pointSize: 36)
        chatButton.setSymbolImage(systemName: "message", pointSize: 36)
    }
    
    private func setupHierarchy() {
        headerStackView.addArrangedSubviews(screenTitle, headerButtonsStackView)
        headerButtonsStackView.addArrangedSubviews(phoneButton, emailButton, chatButton)
        centerStackView.addArrangedSubviews(textViewTitle, textView)
        bottomStackView.addArrangedSubviews(sendMessageButton, backButton)
        addSubview(headerStackView)
        addSubview(centerStackView)
        addSubview(bottomStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            headerButtonsStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 30),
            headerButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerButtonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerButtonsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            phoneButton.heightAnchor.constraint(equalToConstant: 80),
            emailButton.heightAnchor.constraint(equalToConstant: 80),
            chatButton.heightAnchor.constraint(equalToConstant: 80),
            
            phoneButton.widthAnchor.constraint(equalToConstant: 80),
            emailButton.widthAnchor.constraint(equalToConstant: 80),
            chatButton.widthAnchor.constraint(equalToConstant: 80),
            
            centerStackView.topAnchor.constraint(equalTo: headerButtonsStackView.bottomAnchor, constant: 30),
            centerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            centerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            centerStackView.bottomAnchor.constraint(equalTo: sendMessageButton.topAnchor, constant: -30),
            
            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            sendMessageButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
