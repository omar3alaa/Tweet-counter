//
//  TweetCounterUIComponents.swift
//  
//
//  Created by Omar Alaa on 16/10/2022.
//

import Foundation
import UIKit

public class TweetCounterUIComponents {
    private init() { }
    
    public static let shared = TweetCounterUIComponents()
    
    public func initialize() {
        registerFonts()
    }
}

private extension TweetCounterUIComponents {
    func registerFonts() {
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-Black-2", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-Bold-2", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-Heavy-1", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNEXTLTARABIC-LIGHT-1", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-Medium-2", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-Regular-2", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "ArbFONTS-DINNextLTArabic-UltraLight-1", fontExtension: "ttf")
    }
}
