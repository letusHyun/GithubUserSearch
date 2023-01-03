//
//  SearchUserResponse.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/03.
//

import Foundation

struct SearchUserResponse: Decodable {
  var items: [SearchResult]
}
