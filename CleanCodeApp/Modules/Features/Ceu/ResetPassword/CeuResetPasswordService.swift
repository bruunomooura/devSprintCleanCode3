//
//  CeuResetPasswordService.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 20/02/25.
//

protocol CeuResetPasswordServiceProtocol {
    func resetPassword(email: String?) async throws -> CeuResetPasswordResponse
}

class CeuResetPasswordService: CeuResetPasswordServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func resetPassword(email: String?) async throws -> CeuResetPasswordResponse {
        let parameters = try setupResetPasswordRequestParameters(email: email)
        let resetPasswordRequest: NetworkRequest = ResetPasswordRequest()

        return try await withCheckedThrowingContinuation { continuation in
            networkManager.request(resetPasswordRequest) { (result: Result<CeuResetPasswordResponse, Error>) in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func setupResetPasswordRequestParameters(email: String?) throws -> [String: String] {
        guard let email = email else {
            throw CeuCommonsErrors.invalidData
        }

        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }


}

public struct CeuResetPasswordResponse: Decodable {
    let success: Bool
    let message: String?
}

class ResetPasswordRequest: NetworkRequest {
    var pathURL: String = Endpoints.Auth.resetPassword
    var method: HTTPMethod = .post
}
