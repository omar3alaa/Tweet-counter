//
//  NetworkError.swift
//  
//
//  Created by Omar Alaa on 17/10/2022.
//

import Foundation

public enum NetworkError: LocalizedError {
    case noInternetConnection(message: String)
    case dataError(message: String)
    case unKnownError(message: String)
    case notFound(message: String)
    case unAuthorized(message: String)
    case unprocessableEntity(message: String)
    case forbidden(message: String)
    case badRequest(message: String)
    case conflict(message: String)
  
    public init(error: Error) {
        let error = error as NSError
        switch error.code {
        case -1009, -1020:
            self = .noInternetConnection(message: error.localizedDescription)
        case 404:
            self = .notFound(message: error.localizedDescription)
        case 401:
            self = .unAuthorized(message: error.localizedDescription)
        case 422:
            self = .unprocessableEntity(message: error.localizedDescription)
        case 403:
            self = .forbidden(message: error.localizedDescription)
        case 400:
            self = .badRequest(message: error.localizedDescription)
        case 409:
            self = .conflict(message: error.localizedDescription)
        default:
            self = .unKnownError(message: error.localizedDescription)
        }
    }
    
    public init(code: Int) {
        let error = NSError(domain: "", code: code, userInfo: nil)
        self.init(error: error)
    }
    
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection(let message):
            return message
        case .dataError(let message):
            return message
        case .unKnownError(let message):
            return message
        case .notFound(let message):
            return message
        case .unAuthorized(let message):
            return message
        case .unprocessableEntity(let message):
            return message
        case .forbidden(let message):
            return message
        case .badRequest(let message):
            return message
        case .conflict(let message):
            return message
        }
    }
}
