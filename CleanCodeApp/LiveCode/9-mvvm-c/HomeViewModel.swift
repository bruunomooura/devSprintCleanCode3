//
//  HomeViewModel.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func presentLoading()
    func hideLoading()
    func showAlert(text: String)
    func updateTextFields()
}

protocol HomeViewModeling  {
    var delegate: HomeViewModelDelegate? { get set }
    var conversionRate: Double { get }
    var currencyOriginTitle: String { get }
    var currencyDestinyPluralTitle: String { get }
    
    func fetchConversionRate() async
    func getAvailableCurrencies(filterOrigin: Bool) -> [CurrencyTypeProtocol]
    func didUpdateCurrency(isOriginCurrency: Bool, currency: CurrencyTypeProtocol)
}

extension HomeViewModeling {
    func getAvailableCurrencies() -> [CurrencyTypeProtocol] {
        getAvailableCurrencies(filterOrigin: false)
    }
}

class HomeViewModel: HomeViewModeling {
    
    private let availableCurrencies: [CurrencyTypeProtocol]
    private var selectedCurrencyFrom: CurrencyTypeProtocol
    private var selectedCurrencyTo: CurrencyTypeProtocol
    private let currencyService: CurrencyServiceProtocol
    
    private var conversionRate_: Double = 0.0
    
    var conversionRate: Double {
        return conversionRate_
    }
    
    var currencyDestinyPluralTitle: String {
        return selectedCurrencyTo.titlePlural
    }
    
    var currencyOriginTitle: String {
        return selectedCurrencyFrom.title
    }
    
    init(
        selectedCurrencyFrom: CurrencyTypeProtocol,
        selectedCurrencyTo: CurrencyTypeProtocol,
        availableCurrencies: [CurrencyTypeProtocol],
        currencyService: CurrencyServiceProtocol = CurrencyService()
    ) {
        self.selectedCurrencyFrom = selectedCurrencyFrom
        self.selectedCurrencyTo = selectedCurrencyTo
        self.availableCurrencies = availableCurrencies
        self.currencyService = currencyService
    }
    
    weak var delegate: HomeViewModelDelegate?
    
    func getAvailableCurrencies(filterOrigin: Bool) -> [CurrencyTypeProtocol] {
        return filterOrigin ? availableCurrencies : availableCurrencies.filter { $0.title != selectedCurrencyFrom.title }
    }
    
    func didUpdateCurrency(isOriginCurrency: Bool, currency: CurrencyTypeProtocol) {
        if isOriginCurrency {
            self.selectedCurrencyFrom = currency
        } else {
            self.selectedCurrencyTo = currency
        }
        Task {
            await fetchConversionRate()
        }
    }
    
    func fetchConversionRate() async {
        toggleAlert(show: true)
        
        do {
            let rate = try await currencyService.fetchConversionRate(
                from: selectedCurrencyFrom.identifier,
                to: selectedCurrencyTo.identifier
            )
            conversionRate_ = rate
            delegate?.updateTextFields()
        } catch {
            delegate?.showAlert(text: "Erro ao obter dados")
        }
        
        toggleAlert(show: false)
    }
}

private extension HomeViewModel {
    func toggleAlert(show: Bool) {
        if show {
            delegate?.presentLoading()
        } else {
            delegate?.hideLoading()
        }
    }
}
