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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
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
    
    func configureItem(with viewModel: Photo) {
        guard let thumbUrl = URL(string: viewModel.urls.thumb), let imageData = try? Data(contentsOf: thumbUrl) else { return }
        
        self.imageView.image = UIImage(data: imageData)
    }
}
