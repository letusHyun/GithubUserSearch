//
//  Publisher+Utils.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/03.
//

import Foundation
import Combine

extension Publisher {
  static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
    return Fail(error: error).eraseToAnyPublisher()
  }
}
