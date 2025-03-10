//
//  SmallGiftNumberCCell.swift
//  smallGiftDemo
//
//  Created by 王腾 on 2025/3/10.
//

import UIKit
class SmallGiftNumberCCell: UICollectionViewCell {
    
    lazy var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var imageName:String? {
        didSet {
            iconImageView.image = UIImage(named: imageName ?? "")
        }
    }
}
