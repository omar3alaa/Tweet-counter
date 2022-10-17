//
//  PostTweetInteractor.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation

class PostTweetInteractor: PostTweetInteractorProtocol {
    private let service: TweetPostServiceProtocol
    weak var output: PostTweetInteractorOutputProtocol?
    
    init(service: TweetPostServiceProtocol) {
        self.service = service
    }
    
    func postTweetWith(text: String) {
        service.postTweetWith(text: text) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.output?.didPostTweetSuccessfully()
        } onFailure: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.output?.didFailToPostTweetWith(error: error)
        }
    }
}
