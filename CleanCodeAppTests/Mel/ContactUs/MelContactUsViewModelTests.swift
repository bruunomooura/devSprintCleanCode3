//
//  MelContactUsViewModelTests.swift
//  CleanCodeAppTests
//
//  Created by Bruno Moura on 23/02/25.
//

import XCTest
@testable import CleanCode

class MelContactUsViewModelTests: XCTestCase {
    private var externalAppOpener: SpyExternalAppOpener!
    private var contactUsService: SpyMelContactUsService!
    private var delegate: SpyMelContactUsDelegate!
    private var sut: MelContactUsViewModelProtocol!
    
    override func setUp() {
        super.setUp()
        externalAppOpener = SpyExternalAppOpener()
        contactUsService = SpyMelContactUsService()
        sut = MelContactUsViewModel(
            appOpener: externalAppOpener,
            contactUsService: contactUsService
        )
        Task { @MainActor in
            delegate = SpyMelContactUsDelegate()
            sut.setDelegate(delegate: delegate)
        }
    }
    
    override func tearDown() {
        externalAppOpener = nil
        contactUsService = nil
        delegate = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Testes para fetchAndProcessContactData
    
    func test_fetchAndProcessContactData_deveChamarServicoEAtualizarModelo() async {
        // Dado
        let expectedContact = ContactUsModel(
            whatsapp: "+5511999999999",
            phone: "+5511999999999",
            mail: "test@example.com")
        contactUsService.mockedContact = expectedContact
        
        // Quando
        sut.fetchAndProcessContactData()
        await fulfillment(of: [delegate.expectLoading, delegate.expectHideLoading], timeout: 1.0)
        
        // Então
        XCTAssertTrue(contactUsService.fetchContactCalled, "Deveria ter chamado o serviço.")
        Task { @MainActor in
            XCTAssertFalse(delegate.presentErrorAlertCalled, "Não deveria ter apresentado erro.")
        }
    }
    
    func test_fetchAndProcessContactData_deveMostrarErro_quandoServicoFalhar() async {
        // Dado
        contactUsService.shouldThrowFetchError = true
        
        // Quando
        sut.fetchAndProcessContactData()
        await fulfillment(of: [delegate.expectLoading, delegate.expectErrorAlert], timeout: 1.0)
        
        // Então
        XCTAssertTrue(contactUsService.fetchContactCalled, "Deveria ter chamado o serviço.")
        Task { @MainActor in
            XCTAssertTrue(delegate.presentErrorAlertCalled, "Deveria ter apresentado erro.")
        }
    }
    
    // MARK: - Testes para openPhoneForCall
    
    func test_openPhoneForCall_deveAbrirURLCorreta() async {
        // Dado
        let contact = ContactUsModel(
            whatsapp: "+5511999999999",
            phone: "+5511999999999",
            mail: "test@example.com")
        
        // Configurar o contato esperado no serviço
        contactUsService.mockedContact = contact
        
        // Quando
        sut.fetchAndProcessContactData() // Aguarde a chamada assíncrona
        sut.openPhoneForCall()
        await Task.yield() // Espere a tarefa ser concluída
        
        // Então
        XCTAssertTrue(externalAppOpener.openURLCalled, "Deveria ter chamado openUrl.")
    }

    
    func test_openPhoneForCall_naoDeveFazerNada_seTelefoneForNil() async {
        // Quando
        sut.openPhoneForCall()
        
        // Então
        XCTAssertFalse(externalAppOpener.openURLCalled, "Não deveria ter chamado openUrl.")
    }
    
    // MARK: - Testes para sendMessageToSupport
    
    func test_sendMessageToSupport_deveEnviarMensagem_comSucesso() async {
        // Dado
        let contact = ContactUsModel(
            whatsapp: "+5511999999999",
            phone: "+5511999999999",
            mail: "test@example.com")
        contactUsService.mockedContact = contact
        sut.fetchAndProcessContactData()
        
        // Quando
        await sut.sendMessageToSupport(message: "Hello")
        
        // Então
        XCTAssertTrue(contactUsService.sendContactCalled, "Deveria ter chamado sendContactUsMessage.")
        Task { @MainActor in
            XCTAssertTrue(delegate.presentSuccessAlertCalled, "Deveria ter apresentado sucesso.")
        }
    }
    
    func test_sendMessageToSupport_deveMostrarErro_seEnvioFalhar() async {
        // Dado
        let contact = ContactUsModel(
            whatsapp: "+5511999999999",
            phone: "+5511999999999",
            mail: "test@example.com")
        contactUsService.mockedContact = contact
        contactUsService.shouldThrowSendError = true
        sut.fetchAndProcessContactData()
        
        // Quando
        await sut.sendMessageToSupport(message: "Hello")
        
        // Então
        XCTAssertTrue(contactUsService.sendContactCalled, "Deveria ter chamado sendContactUsMessage.")
        Task { @MainActor in
            XCTAssertTrue(delegate.presentErrorAlertCalled, "Deveria ter apresentado erro.")
        }
    }
}

class SpyExternalAppOpener: ExternalAppOpening {
    var openURLCalled = false
    var shouldThrowError = false
    
    func openUrl(_ urlCreator: any CleanCode.ExternalUrlCreator) async throws {
        openURLCalled = true
        if shouldThrowError { throw URLError(.badURL) }
    }
}

class SpyMelContactUsService: MelContactUsServiceProtocol {
    var fetchContactCalled = false
    var sendContactCalled = false
    var shouldThrowFetchError = false
    var shouldThrowSendError = false
    var mockedContact: ContactUsModel?
    
    func fetchContactData() async throws -> ContactUsModel {
        fetchContactCalled = true
        if shouldThrowFetchError { throw URLError(.badServerResponse) }
        return mockedContact ?? ContactUsModel(whatsapp: "", phone: "", mail: "")
    }
    
    func sendContactUsMessage(_ parameters: [String : String]) async throws -> Data {
        sendContactCalled = true
        if shouldThrowSendError { throw URLError(.cannotConnectToHost) }
        return Data()
    }
}

class SpyMelContactUsDelegate: MelContactUsViewModelDelegate {
    var presentLoadingCalled = false
    var hideLoadingCalled = false
    var presentErrorAlertCalled = false
    var presentSuccessAlertCalled = false
    
    let expectLoading = XCTestExpectation(description: "Chamou presentLoading")
    let expectHideLoading = XCTestExpectation(description: "Chamou hideLoading")
    let expectErrorAlert = XCTestExpectation(description: "Chamou presentErrorAlert")
    let expectSuccessAlert = XCTestExpectation(description: "Chamou presentSuccessAlert")
    
    func presentLoading() {
        presentLoadingCalled = true
        expectLoading.fulfill()
    }
    
    func hideLoading() {
        hideLoadingCalled = true
        expectHideLoading.fulfill()
    }
    
    func presentErrorAlert(mustDismiss: Bool) {
        presentErrorAlertCalled = true
        expectErrorAlert.fulfill()
    }
    
    func presentSuccessAlert() {
        presentSuccessAlertCalled = true
        expectSuccessAlert.fulfill()
    }
}
