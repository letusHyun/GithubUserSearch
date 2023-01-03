//
//  NetworkService.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/03.
//

import Foundation
import Combine

enum NetworkError: Error {
  case invalidRequest
  case invalidResponse
  case responseError(StatusCode: Int)
  case jsonDecodingError(error: Error)
}

final class NetworkService {
  let session: URLSession
  
  init(configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
    guard let request = resource.urlRequest else {
      return Fail.fail(NetworkError.invalidRequest)
    }
    
    return session.dataTaskPublisher(for: request)
      .tryMap { result -> Data in
        guard let response = result.response as? HTTPURLResponse, //response 처리
              (200..<300).contains(response.statusCode)
        else {
          let response = result.response as? HTTPURLResponse
          let statusCode = response?.statusCode ?? -1
          throw NetworkError.responseError(StatusCode: statusCode)
        }
        return result.data //data 넘김
      }
      .decode(type: T.self, decoder: JSONDecoder()) //decoding
      .eraseToAnyPublisher()
  }
}
