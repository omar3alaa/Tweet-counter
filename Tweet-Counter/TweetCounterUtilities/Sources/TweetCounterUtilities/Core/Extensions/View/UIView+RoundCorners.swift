//
//  UIView+RoundCorners.swift
//  
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation
import UIKit

public extension UIView {
    func roundCorners(withRadius cornerRadius: CGFloat,
                             borderWidth: CGFloat = 0,
                             borderColor: UIColor? = .clear) {
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        layer.borderWidth   = borderWidth
        layer.borderColor   = borderColor?.cgColor
        layer.cornerRadius  = cornerRadius
        layer.masksToBounds = cornerRadius == 0 ? false : true
        clipsToBounds       = cornerRadius == 0 ? false : true
    }
}
