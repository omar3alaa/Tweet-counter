//
//  TweetCounterViewModel.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import RxSwift
import RxCocoa

class TweetCounterViewModel {
    
    // MARK: - Private properties
    private let tweetCounterManager: TweetCounterManagerProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: -  Input
    let tweetText: PublishSubject<String?> = PublishSubject<String?>()
    let isTextViewEnabled: PublishSubject<Bool> = PublishSubject<Bool>()

    // MARK: Output
    let typedCharacters: Driver<String>
    let remainingCharacters: Driver<String>
    let warningStateOn: Driver<Bool>
    let playErrorFeedback: Driver<Void>
    let shakeLabels: Driver<Void>
    let textViewPlaceholder: Driver<String>
    
    // MARK: Private
    let maximumCharactersAllowed: BehaviorRelay<Int>
    
    init(tweetCounterManager: TweetCounterManagerProtocol) {
        self.tweetCounterManager = tweetCounterManager
        self.maximumCharactersAllowed = BehaviorRelay<Int>(value: tweetCounterManager.maximumChractersAllowed)
        self.textViewPlaceholder = maximumCharactersAllowed.map({ maxCount in
            "Start typing! You can enter up to \(maxCount) characters"
        }).asDriver(onErrorJustReturn: "")
        let textCount = self.tweetText.unwrap().map(tweetCounterManager.getTweetCountFor(tweet:)).share(replay: 1)
        let textExceededMaximumCharactersCountAllowed = textCount.withLatestFrom(maximumCharactersAllowed) { charactersCount, maxCount in
            return charactersCount > maxCount
        }
        warningStateOn = textExceededMaximumCharactersCountAllowed.asDriver(onErrorJustReturn: false)
        let isTypingAfterExceedingLimit = textExceededMaximumCharactersCountAllowed.filter({ $0 }).map({ _ in ()}).share(replay: 1).asDriver(onErrorJustReturn: ())
        
        playErrorFeedback = isTypingAfterExceedingLimit
        shakeLabels = isTypingAfterExceedingLimit
        typedCharacters = textCount.withLatestFrom(maximumCharactersAllowed, resultSelector: {
            "\($0)/\($1)"
        }).asDriver(onErrorJustReturn: "")
        remainingCharacters = textCount.withLatestFrom(maximumCharactersAllowed, resultSelector: {
            "\($1 - $0)"
        }).asDriver(onErrorJustReturn: "")
    }
}


