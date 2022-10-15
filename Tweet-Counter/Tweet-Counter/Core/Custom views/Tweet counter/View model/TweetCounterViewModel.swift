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
    // MARK: Input
    struct Input {
        let tweetText: AnyObserver<String?>
    }
    
    // MARK: Output
    struct Output {
        let tweetText: Driver<String?>
        let typedCharacters: Driver<String>
        let remainingCharacters: Driver<String>
        let warningStateOn: Driver<Bool>
        let playErrorFeedback: Driver<Void>
        let shakeLabels: Driver<Void>
    }

    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var previousCount = 0
    
    // MARK: - Private output properties
    private let tweetText: PublishSubject<String?> = PublishSubject<String?>()
    private let typedCharacters: PublishRelay<String> = PublishRelay<String>()
    private let remainingCharacters: PublishRelay<String> = PublishRelay<String>()
    private let warningStateOn: PublishRelay<Bool> = PublishRelay<Bool>()
    private let playErrorFeedback: PublishRelay<Void> = PublishRelay<Void>()
    private let shakeLabels: PublishRelay<Void> = PublishRelay<Void>()
    
    // MARK: Public properties
    var input: Input
    var output: Output
    
    
    init() {
        input = Input(tweetText: tweetText.asObserver())
        output = Output(tweetText: tweetText.asDriver(onErrorJustReturn: nil),
                        typedCharacters: typedCharacters.asDriver(onErrorJustReturn: ""),
                        remainingCharacters: remainingCharacters.asDriver(onErrorJustReturn: ""),
                        warningStateOn: warningStateOn.asDriver(onErrorJustReturn: false),
                        playErrorFeedback: playErrorFeedback.asDriver(onErrorJustReturn: ()),
                        shakeLabels: shakeLabels.asDriver(onErrorJustReturn: ()))
        bindViewModel()
    }
    
    func bindViewModel() {
        let count = tweetText.unwrap().map {
            $0.count
        }.share(replay: 1)
        
        count.bind { [weak self] count in
            guard let strongSelf = self else { return }
            if count > 280 {
                strongSelf.warningStateOn.accept(true)
                // This code made to check if the user is still writing after being warned that he/she exceeded the characters limit, if yes, then create some error feedback haptic and make labels animate with shaking effect
                if count > strongSelf.previousCount {
                    strongSelf.playErrorFeedback.accept(())
                    strongSelf.shakeLabels.accept(())
                }
            } else {
                strongSelf.warningStateOn.accept(false)
            }
            strongSelf.typedCharacters.accept("\(count)/280")
            strongSelf.remainingCharacters.accept("\(280 - count)")
            strongSelf.previousCount = count
        }.disposed(by: disposeBag)
    }
}


