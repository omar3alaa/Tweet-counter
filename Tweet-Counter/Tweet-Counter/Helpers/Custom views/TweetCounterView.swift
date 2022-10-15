//
//  TweetCounterView.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import UIKit

class TweetCounterView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var typedCharactersLabel: UILabel!
    @IBOutlet private weak var remainingCharactersLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
}

// MARK: Private helpers
private extension TweetCounterView {
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        containerView = view
        setupView()
    }
    
    func setupView() {
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

