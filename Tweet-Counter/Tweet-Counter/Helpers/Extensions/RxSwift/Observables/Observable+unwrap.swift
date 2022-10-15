//
//  Observable+unwrap.swift
//  Tweet-Counter
//
//  Created by Omar Alaa on 15/10/2022.
//

import Foundation
import RxSwift

extension Observable {
    /// Returns an `Observable` where the nil values from the original `Observable` are skipped
    func unwrap<T>() -> Observable<T> where Element == T? {
        self
            .filter { $0 != nil }
            .map { $0! }
    }
}
