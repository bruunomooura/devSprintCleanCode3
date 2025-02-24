//
//  MelLoadingView.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 22/02/25.
//


import Foundation
import UIKit

protocol MelLoadingViewProtocol: AnyObject {
    func showLoadingView(on view: UIView)
    func hideLoadingView()
}

class MelLoadingView: MelLoadingViewProtocol {
    private var loadingView: UIView = UIView()

    func showLoadingView(on view: UIView) {
        loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = .systemGray2.withAlphaComponent(0.8)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .blue
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        loadingView.alpha = 0.0
        UIView.animate(withDuration: 0.6) {
            self.loadingView.alpha = 1.0
        }
    }

    func hideLoadingView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.loadingView.alpha = 0.0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
    }
}
