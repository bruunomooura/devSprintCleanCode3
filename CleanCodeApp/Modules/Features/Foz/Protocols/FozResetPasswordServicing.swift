//
//  ResetPasswordServicing.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//
import Foundation
import UIKit

protocol FozResetPasswordServicing {
    func performPasswordReset(from presenter: UIViewController,
                             with parameters: [String: String],
                             completion: @escaping (Bool) -> Void)
}
