//
//  CeuResetPasswordViewModelTests.swift
//  CleanCodeAppTests
//
//  Created by Jorge de Carvalho on 21/02/25.
//

import XCTest
@testable import CleanCode

class CeuResetPasswordServiceMock: CeuResetPasswordServiceProtocol {
    var shouldReturnError = false
    var wasCalled = false

    func resetPassword(email: String?) async throws -> CleanCode.CeuResetPasswordResponse {
        wasCalled = true
        if shouldReturnError {
            throw CeuCommonsErrors.networkError
        }

        return CeuResetPasswordResponse(
            success: true,
            message: "Success Message!"
        )
    }
}

class CeuResetPasswordViewModelDelegateMock: CeuResetPasswordViewModelDelegate {
    var validateFormShouldReturnError = false
    var validateFormWasCalled = false
    var handleResetPasswordRequestSuccessWasCalled = false
    var handleResetPasswordRequestErrorWasCalled = false
    var showAlertWithWasCalled = false
    var showNoInternetConnectionAlertWasCalled = false
    var showAlertWithMessage = ""
    var onHandleResetPasswordRequestSuccess: (() -> Void)?
    var onHandleResetPasswordRequestError: (() -> Void)?


    func handleResetPasswordRequestSuccess() {
        handleResetPasswordRequestSuccessWasCalled = true
        onHandleResetPasswordRequestSuccess?()
    }
    
    func handleResetPasswordRequestError() {
        handleResetPasswordRequestErrorWasCalled = true
        onHandleResetPasswordRequestError?()
    }
    
    func validateForm() throws {
        validateFormWasCalled = true

        if validateFormShouldReturnError {
            throw CeuCommonsErrors.invalidEmail
        }
    }
    
    func showAlertWith(message: String) {
        showAlertWithWasCalled = true
        showAlertWithMessage = message
    }
    
    func showNoInternetConnectionAlert() {
        showNoInternetConnectionAlertWasCalled = true
    }
}

class ConnectivityManagerMock: ConnectivityManagerProxy {
    var shouldReturnIsConnected = true
    var wasCalled = false

    var isConnected: Bool {
        wasCalled = true
        return shouldReturnIsConnected
    }


}

class CeuResetPasswordViewModelTests: XCTestCase {
    lazy var ceuResetPasswordViewModelDelegateMock: CeuResetPasswordViewModelDelegateMock = {
        let ceuResetPasswordViewModelDelegateMock = CeuResetPasswordViewModelDelegateMock()
        return ceuResetPasswordViewModelDelegateMock
    }()
    lazy var ceuResetPasswordServiceMock: CeuResetPasswordServiceMock = {
        let ceuResetPasswordServiceMock = CeuResetPasswordServiceMock()
        return ceuResetPasswordServiceMock
    }()
    lazy var connectivityManagerMock: ConnectivityManagerMock = {
        let connectivityManagerMock = ConnectivityManagerMock()
        return connectivityManagerMock
    }()
    lazy var sut: CeuResetPasswordViewModelProtocol? = {
        let sut = CeuResetPasswordViewModel(resetPasswordService: self.ceuResetPasswordServiceMock, connectivityManager: self.connectivityManagerMock)
        sut.delegate = self.ceuResetPasswordViewModelDelegateMock
        return sut
    }()

    func test_startRecoverPasswordWith_should_call_showAlertWith_function_when_validateForm_return_error() {
        // Given
        ceuResetPasswordViewModelDelegateMock.validateFormShouldReturnError = true

        // When
        sut?.startRecoverPasswordWith(email: nil)

        // Then
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock.showAlertWithMessage, CeuResetPasswordStrings.verifyEmailErrorMessage.localized())
        XCTAssertTrue(ceuResetPasswordViewModelDelegateMock.showAlertWithWasCalled)
    }

    // TODO: Create mock to ConnectivityManager
    func test_startRecoverPasswordWith_should_call_showAlertWith_function_when_verifyInternetConnection_return_error() {
        // Given
        connectivityManagerMock.shouldReturnIsConnected = false

        // When
        sut?.startRecoverPasswordWith(email: "jorge@devsprint.com")

        // Then
        XCTAssertTrue(ceuResetPasswordViewModelDelegateMock.showNoInternetConnectionAlertWasCalled)
        XCTAssertTrue(ceuResetPasswordViewModelDelegateMock.showAlertWithWasCalled)
        XCTAssertEqual(ceuResetPasswordViewModelDelegateMock.showAlertWithMessage, CeuResetPasswordStrings.somethingWentWrongErrorMessage.localized())
    }

    func test_when_makeResetPasswordRequest_return_error_handleResetPasswordRequestError_should_be_called() {
        // Given
        ceuResetPasswordServiceMock.shouldReturnError = true
        let expectation = expectation(description: "request resetPassword done")

        ceuResetPasswordViewModelDelegateMock.onHandleResetPasswordRequestError = {
            expectation.fulfill()
        }

        // When
        sut?.startRecoverPasswordWith(email: nil)

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertTrue(self.ceuResetPasswordServiceMock.wasCalled)
        XCTAssertTrue(self.ceuResetPasswordViewModelDelegateMock.handleResetPasswordRequestErrorWasCalled)
    }

    func test_when_makeResetPasswordRequest_return_success_handleResetPasswordRequestSuccess_should_be_called() {
        // Given
        ceuResetPasswordServiceMock.shouldReturnError = false
        let expectation = expectation(description: "request resetPassword done")

        ceuResetPasswordViewModelDelegateMock.onHandleResetPasswordRequestSuccess = {
            expectation.fulfill()
        }

        // When
        sut?.startRecoverPasswordWith(email: "jorge@devsprint.com")

        wait(for: [expectation], timeout: 1)

        // Then
        XCTAssertTrue(ceuResetPasswordServiceMock.wasCalled)
        XCTAssertTrue(ceuResetPasswordViewModelDelegateMock.handleResetPasswordRequestSuccessWasCalled)
    }
}
