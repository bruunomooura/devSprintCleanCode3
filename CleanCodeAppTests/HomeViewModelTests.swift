//
//  HomeViewModel.swift
//  CleanCodeAppTests
//
//  Created by Pedro Menezes on 21/02/25.
//

import XCTest
@testable import CleanCode

enum TestsError: Error {
    case errorSetter
}

class MockService: CurrencyServiceProtocol {
    var originValue: String?
    var destinyValue: String?
    var shouldReturnError: Bool = false
    var doubleSetter: Double = 0
    
    var didCallFetchConversionRate = false
    
    func fetchConversionRate(from origin: String, to destiny: String) async throws -> Double {
       didCallFetchConversionRate = true
        originValue = origin
        destinyValue  = destiny
        
        if shouldReturnError {
            throw TestsError.errorSetter
        } else {
            return doubleSetter
        }
    }
}

class MockDelegate: HomeViewModelDelegate {
    var didCallUpdateTextFields = false
    var didCallPresentLoading = false
    var didCallHideLoading = false
    var didCallShowAlert = false
    var showAlertParameterObserver = ""
    
    func presentLoading() {
        didCallPresentLoading = true
    }
    
    func hideLoading() {
        didCallHideLoading = true
    }
    
    func showAlert(text: String) {
        didCallShowAlert = true
        showAlertParameterObserver = text
    }
    
    func updateTextFields() {
        didCallUpdateTextFields = true
    }
}

class HomeViewModelTests: XCTestCase {
    
    private let originCurrency = BrlCurrency()
    private let destinyCurrency = USDCurrency()
    private let thirdCurrency = EURCurrency()
    private let mockService = MockService()
    private let mockDelegate = MockDelegate()
    
    lazy var sut: HomeViewModel = {
        let vm = HomeViewModel(selectedCurrencyFrom: originCurrency,
                               selectedCurrencyTo: destinyCurrency,
                               availableCurrencies: [
                                originCurrency,
                                destinyCurrency,
                                thirdCurrency,
                               ],
                               currencyService: mockService)
        vm.delegate = mockDelegate
        return vm
        
    }()
    
    func testFetchConversionRate_givenAPISucced_thenCallUpdateTextfield() async {
        //given
        //arrange
        mockService.shouldReturnError = false
        mockService.doubleSetter = 5
        
        //when
        //act
        await sut.fetchConversionRate()
        
        //then
        //assert
        XCTAssertTrue(mockService.didCallFetchConversionRate)
        XCTAssertTrue(mockDelegate.didCallUpdateTextFields)
        XCTAssertEqual(mockService.originValue, originCurrency.identifier)
        XCTAssertEqual(mockService.destinyValue, destinyCurrency.identifier)
        
        XCTAssertTrue(mockDelegate.didCallPresentLoading)
        XCTAssertTrue(mockDelegate.didCallHideLoading)
    }
    
    func testFetchConversionRate_givenAPINotSucced_thenCallShowAlert() async {
        //given
        //arrange
        mockService.shouldReturnError = true
        
        //when
        //act
        await sut.fetchConversionRate()
        
        //then
        //assert
        XCTAssertTrue(mockService.didCallFetchConversionRate)
        XCTAssertTrue(mockDelegate.didCallShowAlert)
        XCTAssertEqual(mockDelegate.showAlertParameterObserver, "Erro ao obter dados")

        XCTAssertEqual(mockService.originValue, originCurrency.identifier)
        XCTAssertEqual(mockService.destinyValue, destinyCurrency.identifier)
        
        XCTAssertTrue(mockDelegate.didCallPresentLoading)
        XCTAssertTrue(mockDelegate.didCallHideLoading)
    }

}
