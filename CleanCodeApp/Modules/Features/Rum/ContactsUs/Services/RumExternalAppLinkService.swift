//
//  RumExternalAppLinkService.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 21/02/25.
//

import UIKit

protocol RumExternalAppLinkServicing {
    func openExternalAppLink(_ externalLink: RumExternalLinkHandler)
}

final class RumExternalAppLinkService: RumExternalAppLinkServicing {
    func openExternalAppLink(_ externalLink: RumExternalLinkHandler) {
        guard let url = externalLink.url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let fallbackURL = externalLink.fallbackURL {
            UIApplication.shared.open(fallbackURL, options: [:], completionHandler: nil)
        }
    }
}
