//
//  CeuResetPaswordStrings.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 20/02/25.
//

enum CeuResetPasswordStrings: String {
    // MARK: View Model Strings
    case verifyEmailErrorMessage = "Verifique o e-mail informado."
    case somethingWentWrongErrorMessage = "Algo de errado aconteceu. Tente novamente mais tarde."

    // MARK: View Controller Strings
    case initFatalErrorMessage = "init(coder:) has not been implemented. Use init(coder:viewModel:coordinator:) instead."
    case goBack = "Voltar"

    // MARK: Coordinator Strings
    case ops = "Ops..."
    case ok = "OK"

    // MARK: CeuGlobalsProtocol Strings
    case noConnection = "Sem Conexão"
    case connectToInternetErroMessage = "Conecte-se à internet para tentar novamente"

    func localized() -> String {
        return self.rawValue
    }
}
