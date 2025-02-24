//
//  ButtonStyler.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 08/02/25.
//

import Foundation
import UIKit

extension UIButton{

    func applyPrimaryButtonStyle(){
        layer.cornerRadius = bounds.height / 2
        backgroundColor = .blue
        setTitleColor(.white, for: .normal)
    }

    func applySecondaryButtonStyle(){
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
        backgroundColor = .white
        setTitleColor(.blue, for: .normal)
    }

}
