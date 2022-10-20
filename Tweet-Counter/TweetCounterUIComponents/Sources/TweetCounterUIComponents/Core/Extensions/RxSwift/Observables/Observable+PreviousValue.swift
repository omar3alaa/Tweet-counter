//
//  Observable+PreviousValue.swift
//  
//
//  Created by Omar Alaa on 18/10/2022.
//

import Foundation
import RxSwift

extension Observable {
  func withPrevious() -> Observable<(Element?, Element)> {
    return scan([], accumulator: { (previous, current) in
        Array(previous + [current]).suffix(2)
      })
      .map({ (arr) -> (previous: Element?, current: Element) in
        (arr.count > 1 ? arr.first : nil, arr.last!)
      })
  }
}
