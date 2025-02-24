//
//  RumContactUsAPIService .swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import Foundation

protocol RumContactUsAPIServiceDelegate: AnyObject {
    func showAlertMessage(title: String, message: String, shouldDismiss: Bool)
}

protocol RumContactAPIServicing {
    func fetchContactUsData() async -> ContactUsModel
    func sendMessage(parameters: [String: String]) async
}

final class RumContactUsAPIService: RumContactAPIServicing {
    weak var delegate: RumContactUsAPIServiceDelegate?
    
    func fetchContactUsData() async -> ContactUsModel {
        let url = Endpoints.contactUs
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .get, parameters: nil, headers: nil) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    guard let contactUsModel = self.decodeContactUsData(data) else { return }
                    continuation.resume(returning: contactUsModel)
                case .failure(_):
                    self.logError(error: .networkError)
                    self.delegate?.showAlertMessage(
                        title: "Ops..",
                        message: "Ocorreu algum erro",
                        shouldDismiss: true)
                }
            }
        }
    }
    
    private func decodeContactUsData(_ data: Data) -> ContactUsModel? {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ContactUsModel.self, from: data)
            return model
        } catch {
            logError(error: .decodingError)
            return nil
        }
    }
    
    func sendMessage(parameters: [String: String]) async {
        let url = Endpoints.sendMessage
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { response in
                switch response {
                case .success:
                    self.delegate?.showAlertMessage(
                        title: "Sucesso..",
                        message: "Sua mensagem foi enviada",
                        shouldDismiss: true
                    )
                case .failure(_):
                    self.logError(error: .networkError)
                    self.delegate?.showAlertMessage(
                        title: "Ops..",
                        message: "Ocorreu algum erro",
                        shouldDismiss: false)
                }
            }
        }
    }
    
    private func logError(error: RumContactUsError) {
        print("Log error: \(error.logMessage)")
    }
}
