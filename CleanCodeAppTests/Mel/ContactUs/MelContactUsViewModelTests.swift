//
//  MelContactUsViewModelTests.swift
//  CleanCodeAppTests
//
//  Created by Bruno Moura on 23/02/25.
//

import XCTest
@testable import CleanCode

class MelContactUsViewModelTests: XCTestCase {
    private let externalAppOpener: ExternalAppOpening = SpyExternalAppOpener()
    private let contactUsService: MelContactUsServiceProtocol = SpyMelContactUsService()
    let sut: MelContactUsViewModelProtocol = MelContactUsViewModel(
        appOpener: externalAppOpener,
        contactUsService: contactUsService
    )
}

class SpyExternalAppOpener: ExternalAppOpening {
    public var openURL: Bool = false
    func openUrl(_ urlCreator: any CleanCode.ExternalUrlCreator) async throws {
        openURL = true
    }
}

class SpyMelContactUsService: MelContactUsServiceProtocol {
    public var fetchContactSuccess: Bool = false
    public var sendContactUsMessageSuccess: Bool = false
    
    func fetchContactData() async throws -> CleanCode.ContactUsModel {
        fetchContactSuccess = true
    }
    
    func sendContactUsMessage(_ parameters: [String : String]) async throws -> Data {
        sendContactUsMessageSuccess = true
    }
}

//class SpyMelLoadingView: MelLoadingViewProtocol {
//    var showLoadingViewCalled = false
//    var hideLoadingViewCalled = false
//    
//    func showLoadingView(on view: UIView) {
//        showLoadingViewCalled = true
//    }
//    
//    func hideLoadingView() {
//        hideLoadingViewCalled = true
//    }
//}
//
//class SpyMelAlertDisplay: MelAlertDisplayProtocol {
//    var displayErrorAlertCalled = false
//    var displaySuccessAlertCalled = false
//    var displayErrorAlertMustDismiss: Bool?
//    
//    func displaySuccessAlert(on viewController: UIViewController, completion: (() -> Void)?) {
//        displaySuccessAlertCalled = true
//    }
//    
//    func displayErrorAlert(on viewController: UIViewController, mustDismiss: Bool) {
//        displayErrorAlertCalled = true
//        displayErrorAlertMustDismiss = mustDismiss
//    }
//}
