//
//  PhotoCollectionViewCell.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/09.
//

import UIKit

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: SearchPhotoCollectionViewCell.self)
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .white
        button.configuration = .plain()
        button.addTarget(self, action: #selector(didTapFavoriteButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
        setUpFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        favoriteButton.tintColor = nil
    }
    
    private func setUpImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])
    }
    
    private func setUpFavoriteButton() {
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    func configureItem(with viewModel: Photo) {
        guard let thumbUrl = URL(string: viewModel.imagePath), let imageData = try? Data(contentsOf: thumbUrl) else { return }
        
        self.imageView.image = UIImage(data: imageData)
    }
}

extension SearchPhotoCollectionViewCell {
    @objc private func didTapFavoriteButton(_ sender: UIButton) {
        print(#function)
    }
}
