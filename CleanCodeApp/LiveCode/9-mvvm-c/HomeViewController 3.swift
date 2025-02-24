//
//  HomeViewController 3.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import UIKit

enum HomeFactory3 {
    static func make() -> UIViewController {
        let availableCurrencies: [CurrencyTypeProtocol] = [
            BrlCurrency(),
            USDCurrency(),
            EURCurrency(),
            AUSCurrency()
        ]
        let coordinator = HomeCoordinator3()
        let viewModel = HomeViewModel(selectedCurrencyFrom: availableCurrencies[1],
                                      selectedCurrencyTo: availableCurrencies[0],
                                      availableCurrencies: availableCurrencies)
        let controller = HomeViewController3(viewModel: viewModel,
                                             coordinator: coordinator)
        viewModel.delegate = controller
        coordinator.controller = controller
        return controller
    }
}

class HomeViewController3: UIViewController, UITextFieldDelegate {
    private let homeView = HomeView()
    private let viewModel: HomeViewModeling
    private let coordinator: HomeCoordinating
    
    override func loadView() {
        self.view = homeView
    }
    
    init(
        viewModel: HomeViewModeling,
        coordinator: HomeCoordinating
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        updateLabels()
        homeView.currencySelectedLabel.text = viewModel.currencyOriginTitle
        
        title = "Conversor de Moeda"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(logoutTapped))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didClickView))
        view.addGestureRecognizer(tapGesture)
        Task.init {
            await viewModel.fetchConversionRate()
        }
    }
    
    @objc
    func didClickView() {
        view.endEditing(true)
    }
    
    private func setupActions() {
        homeView.selectCurrencyToButton.addTarget(self, action: #selector(selectCurrencyToTapped), for: .touchUpInside)
        homeView.currencyInputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        homeView.selectCurrencyFromButton.addTarget(self, action: #selector(selectCurrencyFromTapped), for: .touchUpInside)
    }
    
    @objc private func logoutTapped() {
        coordinator.logout()
    }

    
    @objc private func selectCurrencyFromTapped() {
        let availableCurrencies = viewModel.getAvailableCurrencies()
        coordinator.showAlert(availableCurrencies: availableCurrencies,
                              title: "Selecione a moeda") { currency in
            self.viewModel.didUpdateCurrency(isOriginCurrency: true,
                                        currency: currency)
            self.homeView.currencySelectedLabel.text = currency.title
        }
    }
    
    @objc private func selectCurrencyToTapped() {
        let availableCurrencies = viewModel.getAvailableCurrencies(filterOrigin: true)
        coordinator.showAlert(availableCurrencies: availableCurrencies,
                              title: "Selecione a moeda de destino") { currency in
            self.viewModel.didUpdateCurrency(isOriginCurrency: false,
                                        currency: currency)
            self.updateLabels()
        }
        
    }
    
    private func updateLabels() {
        homeView.currencyInputField.text = "1.00"
        homeView.convertedValueLabel.text = "--"
    }
    
    @objc private func textFieldDidChange() {
        guard let text = homeView.currencyInputField.text,
              let value = Double(text) else {
            homeView.convertedValueLabel.text = "--"
            return
        }
        let convertedValue = value * viewModel.conversionRate
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        
        if let formattedValue = formatter.string(from: NSNumber(value: convertedValue)) {
            homeView.convertedValueLabel.text = "\(formattedValue) \(viewModel.currencyDestinyPluralTitle)"
        } else {
            homeView.convertedValueLabel.text = "--"
        }
    }
    
}
extension HomeViewController3: HomeViewModelDelegate {
    func presentLoading() {
        homeView.convertedValueLabel.text = ""
        homeView.loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        homeView.loadingIndicator.stopAnimating()
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Erro", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateTextFields() {
        self.textFieldDidChange()
    }
    
    
}
