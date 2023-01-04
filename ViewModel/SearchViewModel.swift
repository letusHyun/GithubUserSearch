//
//  SearchViewModel.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/05.
//

import Foundation
import Combine
final class SearchViewModel {
  var networkService: NetworkService!
   
  init(network: NetworkService) {
    networkService = network
  }
  
  //Output: Data
//  @Published private(set) var users: [SearchResult] = [] // == CurrentValueSubject
  let users = CurrentValueSubject<[SearchResult], Never>([])
  var subscriptions = Set<AnyCancellable>()
  
  //Input: User Action
  func search(keyword: String) {
    let resource = Resource<SearchUserResponse>(
      base: "https://api.github.com/",
      path: "search/users",
      params: ["q" : keyword],
      header: ["Content-Type" : "application/json"]
    )
    
    self.networkService.load(resource)
      .map { $0.items }
      .replaceError(with: [])
      .receive(on: RunLoop.main)
//      .assign(to: \.users, on: self)
      .sink(receiveValue: { [weak self] value in
        self?.users.send(value)
      })
      .store(in: &subscriptions)
  }
}
