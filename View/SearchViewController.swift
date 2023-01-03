//
//  SearchViewController.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/02.
//

import UIKit
import SnapKit
import Then
import Combine

class SearchViewController: UIViewController {
  var networkService = NetworkService(configuration: .default)
  
  @Published private(set) var users: [SearchResult] = []
  var subscriptions = Set<AnyCancellable>()
  
  typealias Item = SearchResult
  var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
  
  enum Section {
    case main
  }
  
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    
    let cv = UICollectionView(frame: .zero, collectionViewLayout: self.layout()) //layout: layer를 생성 인자로 주입함
    cv.register(ResultCell.self, forCellWithReuseIdentifier: "ResultCell")
    cv.isScrollEnabled = true
    cv.showsVerticalScrollIndicator = true
    cv.showsHorizontalScrollIndicator = false
    cv.backgroundColor = .clear
    cv.clipsToBounds = true
    cv.contentInset = .zero

    return cv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    embedSearchControl()
    setup()
    configureCollectionView() //dataSource
    bind() //snapshot
  }
  
  private func setup() {
    setupLayout()
    setupStyles()
    setupConstraints()
  }
  
  private func setupLayout() {
    self.view.addSubview(collectionView)
  }
  
  private func setupStyles() {
    self.view.backgroundColor = .white
    
    self.navigationItem.title = "Search"
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func embedSearchControl() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search ID"
    searchController.searchBar.delegate = self //delegate
//    searchController.searchResultsUpdater = self
    
    self.navigationItem.searchController = searchController
  }

  private func configureCollectionView() {
    //1.datasource
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView,
                                                                   cellProvider: { collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell
      else { return nil}
      cell.configure(item)
      
      return cell
    })
  }
  
  //2.layout
  private func layout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func bind() {
    //3.snapshot
    $users
      .receive(on: RunLoop.main)
      .sink { [weak self] users in
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users, toSection: .main)
        self?.dataSource.apply(snapshot)
      }.store(in: &subscriptions)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    guard let keyword = searchBar.text else { return }
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
      .assign(to: \.users, on: self)
      .store(in: &subscriptions)
  }
}
