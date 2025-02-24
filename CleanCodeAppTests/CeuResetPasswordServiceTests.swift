//
//  CeuResetPasswordServiceTests.swift
//  CleanCodeAppTests
//
//  Created by Jorge de Carvalho on 21/02/25.
//

import XCTest
@testable import CleanCode

class NetworkManagerMock: NetworkManagerProtocol {
    var shouldReturnError = false
    var wasCalled = false
    var responseMock = CeuResetPasswordResponse(
        success: true,
        message: "Success message!"
    )

    func request<T>(_ request: any CleanCode.NetworkRequest, completion: @escaping CleanCode.NetworkResult<T>) where T : Decodable {
        wasCalled = true

        if shouldReturnError {
            completion(.failure(NetworkError.networkError))
            return
        }
        completion(.success(responseMock as! T))
    }
    

}

class CeuResetPasswordServiceTests: XCTestCase {
    lazy var networkManagerMock: NetworkManagerMock = {
        let networkManagerMock = NetworkManagerMock()
        return networkManagerMock
    }()
    lazy var sut: CeuResetPasswordServiceProtocol? = {
        let sut = CeuResetPasswordService(networkManager: self.networkManagerMock)
        return sut
    }()

    func testResetPassword_givenEmailIsNil_thenShouldReturnError() async throws {
        // Given

        // When
        do {
            _ = try await sut?.resetPassword(email: nil)

        // Then
            XCTFail("resetPassword function should return an error.")
        } catch {
            XCTAssertEqual(error as? CeuCommonsErrors, CeuCommonsErrors.invalidData)
            XCTAssertFalse(networkManagerMock.wasCalled)
        }
    }

    func testResetPassword_givenApiFail_thenShouldReturnError() async throws {
        // Given
        networkManagerMock.shouldReturnError = true

        // When
        do {
            _ = try await sut?.resetPassword(email: "jorge@devsprint.com")

        // Then
            XCTFail("resetPassword function should return an error.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.networkError)
            XCTAssertTrue(networkManagerMock.wasCalled)
        }
    }

    func test_resetPassword_should_return_success_when_networkManager_request_return_success() async throws {
        // Given
        networkManagerMock.shouldReturnError = false

        // When
        do {
            let response = try await sut?.resetPassword(email: "jorge@devsprint.com")

        // Then
            XCTAssertEqual(response?.message, "Success message!")
        } catch {
            XCTFail("resetPassword function should return success.")
        }
    }

}
