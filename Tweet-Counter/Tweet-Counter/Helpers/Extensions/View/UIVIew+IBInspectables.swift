//
//  UIVIew+IBInspectables.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        set (radius) {
            layer.cornerRadius = radius
            layer.masksToBounds = radius > 0
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        set (borderWidth) {
            layer.borderWidth = borderWidth
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor:UIColor? {
        set (color) {
            layer.borderColor = color?.cgColor
        }
        
        get {
            if let color = layer.borderColor
            {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable
    public var shadowOffset : CGSize {
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }

        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable
    public var shadowColor : UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
    }
    
    @IBInspectable
    public var shadowOpacity : Float {
        set {
            layer.shadowOpacity = newValue
        }
        
        get {
            return layer.shadowOpacity
        }
    }
}
