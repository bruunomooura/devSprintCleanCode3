//
//  MelAlertDisplayProtocol.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 23/02/25.
//

import UIKit

protocol MelAlertDisplayProtocol: AnyObject where Self: UIViewController {
    func displaySuccessAlert()
    func displayErrorAlert(mustDismiss: Bool)
}

extension MelAlertDisplayProtocol {
    func displaySuccessAlert() {
        let alert = UIAlertController(
            title: MelContactUsStrings.successAlertTitle.rawValue,
            message: MelContactUsStrings.successAlertMessage.rawValue,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func displayErrorAlert(mustDismiss: Bool) {
        let alert = UIAlertController(
            title: MelContactUsStrings.errorAlertTitle.rawValue,
            message: MelContactUsStrings.errorAlertMessage.rawValue,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if mustDismiss {
                self.dismiss(animated: true)
            }
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
