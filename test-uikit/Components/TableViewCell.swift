//
//  TableViewCell.swift
//  test-uikit
//
//  Created by Crystalwing Bakaboe on 6/16/23.
//

import UIKit

class TableViewCell: UITableViewCell {
  
  lazy var thumbnailImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 2
    imageView.clipsToBounds = true
    imageView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1)
    imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return imageView
  }()
  
  lazy var rightThumbnailImageView: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 2
    imageView.clipsToBounds = true
    imageView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1)
    imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    return imageView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .title2)
    label.textColor = .label
    label.numberOfLines = 0
    label.textAlignment = .left
    label.minimumScaleFactor = 0.67
    label.lineBreakMode = .byTruncatingTail
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return label
  }()
  
  lazy var stackView: UIStackView = {
    let view = UIStackView(frame: .zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .horizontal
    view.spacing = 8
    view.distribution = .equalSpacing
    view.alignment = .center
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonSetup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func commonSetup() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    
    contentView.addSubview(stackView)
    
    stackView.addArrangedSubview(thumbnailImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(rightThumbnailImageView)
    
    NSLayoutConstraint.activate([
      stackView.heightAnchor.constraint(equalToConstant: 100),
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
      thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
      rightThumbnailImageView.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
      rightThumbnailImageView.widthAnchor.constraint(equalTo: rightThumbnailImageView.heightAnchor),
    ])
  }
  
  func updateData(with item: ItemModel) {
    self.titleLabel.text = item.title
    self.rightThumbnailImageView.image = UIImage(named: item.imageName)
  }
  
  func updateImage(_ image: UIImage?) {
    self.thumbnailImageView.image = image
  }
  
}
