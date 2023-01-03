//
//  Resource.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/03.
//

import Foundation

struct Resource<T: Decodable> {
  var base: String
  var path: String
  var params: [String : String]
  var header: [String : String]
  
  var urlRequest: URLRequest? {
    var urlComponents = URLComponents(string: base + path)!
    let queryItems = params.map { (key: String, value: String) in
      return URLQueryItem(name: key, value: value)
    }
    urlComponents.queryItems = queryItems
    
    var request = URLRequest(url: urlComponents.url!)
    header.map { (key: String, value: String) in
      request.addValue(value, forHTTPHeaderField: key)
    }
    
    return request
  }
  
  init(base: String, path: String, params: [String : String] = [:], header: [String : String] = [:]) {
    self.base = base
    self.path = path
    self.params = params
    self.header = header
  }
}
