//
//  TweetCounterView.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import TweetCounterUtilities

public class TweetCounterView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var typedCharactersLabel: UILabel!
    @IBOutlet private weak var remainingCharactersLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    weak var delegate: TweetCounterDelegate?
    var viewModel: TweetCounterViewModel? {
        didSet {
            bindUI()
            bindViewModel()
        }
    }
    
    // MARK: Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLabelsColors()
    }
    
    public func setDelegate(delegate: TweetCounterDelegate) {
        self.delegate = delegate
    }
    
    public func clearText() {
        textView.rx.text.onNext("")
    }
}

// MARK: Private helpers
private extension TweetCounterView {
    func loadViewFromNib() {
        let bundle = Bundle.module
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        containerView = view
        setupView()
        setupViewModel()
    }
    
    func setupView() {
        setupTextView()
        setupLabelsColors()
    }
    
    func setupTextView() {
        textView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func setupLabelsColors() {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let color: UIColor = userInterfaceStyle == .dark ? .white : .black
        remainingCharactersLabel.textColor = color
        typedCharactersLabel.textColor = color
    }
    
    func setupViewModel() {
        let factory = TweetCounterViewModelFactory()
        self.viewModel = factory.initTweetCounterViewModel()
    }
    
    func bindUI() {
        viewModel?.output.remainingCharacters.drive(remainingCharactersLabel.rx.text).disposed(by: disposeBag)
        viewModel?.output.typedCharacters.drive(typedCharactersLabel.rx.text).disposed(by: disposeBag)
        viewModel?.output.tweetText.drive(textView.rx.text).disposed(by: disposeBag)
        viewModel?.output.warningStateOn.drive(onNext: { [weak self] warningStateOn in
            guard let strongSelf = self else { return }
            if warningStateOn {
                let color: UIColor = .red
                strongSelf.remainingCharactersLabel.textColor = color
                strongSelf.typedCharactersLabel.textColor = color
            } else {
                strongSelf.setupLabelsColors()
            }
            strongSelf.delegate?.typedCharactersCountChanged(didReachMaximumCharactersCountAllowed: warningStateOn)
        }).disposed(by: disposeBag)
        viewModel?.output.playErrorFeedback.throttle(.seconds(1), latest: false).drive(onNext: { _ in
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }).disposed(by: disposeBag)
        viewModel?.output.shakeLabels.throttle(.seconds(1), latest: false).drive(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.remainingCharactersLabel.shake(duration: 1)
            strongSelf.typedCharactersLabel.shake(duration: 1)
        }).disposed(by: disposeBag)
        viewModel?.output.textViewPlaceholder.drive(onNext: { [weak self] placeholder in
            guard let strongSelf = self else { return }
            strongSelf.textView.placeholder = placeholder
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        textView.rx.text.asDriver().drive { [weak self] text in
            guard let strongSelf = self else { return }
            strongSelf.viewModel?.input.tweetText.onNext(text)
            strongSelf.delegate?.didChangeText(newText: text)
        }.disposed(by: disposeBag)
    }
}

