//
//  PhotoCollectionViewCell.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/04/09.
//

import UIKit

class SearchPhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: SearchPhotoCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
