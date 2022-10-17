//
//  AuthorizeTwitterInteractor.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation

class AuthorizeTwitterInteractor: AuthorizeTwitterInteractorProtocol {
    private let service: TwitterAuthorizationServiceProtocol
    weak var output: AuthorizeTwitterInteractorOutputProtocol?
    
    init(service: TwitterAuthorizationServiceProtocol) {
        self.service = service
    }
    
    func authorizeTwitter() {
        service.authorizeTwitter { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.output?.didAuthorizeTwitterSuccessfully()
        } onFailure: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.output?.didFailToAuthorizeTwitterWith(error: error)
        }
    }
}
