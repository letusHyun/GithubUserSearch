//
//  SearchResult.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/03.
//

import Foundation

struct SearchResult: Hashable, Identifiable, Decodable {
  var id: Int64
  var login: String
  var avatarUrl: String
  var htmlUrl: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case login
    case avatarUrl = "avatar_url"
    case htmlUrl = "html_url"
  }
}
