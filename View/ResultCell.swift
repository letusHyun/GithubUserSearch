//
//  ResultCell.swift
//  GithubUserSearch
//
//  Created by SeokHyun on 2023/01/02.
//

import UIKit
import Then
import SnapKit

class ResultCell: UICollectionViewCell {
  
  let userLabel = UILabel().then {
    $0.textColor = .black
    $0.text = "user name"
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  
  //must call super
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  //we have to implement this initializer, but will only ever use this class programmatically
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ searchResult: SearchResult) {
    userLabel.text = searchResult.login
  }
  
  private func setup() {
    setupLayout()
    setupConstraints()
    setupStyles()
  }
  
  private func setupLayout() {
    self.contentView.addSubview(userLabel)
  }
  
  private func setupConstraints() {
    userLabel.snp.makeConstraints {
      $0.leading.equalTo(self.contentView).offset(30)
      $0.centerY.equalTo(self.contentView)
    }
  }
  
  private func setupStyles() {
    
  }
  
}
