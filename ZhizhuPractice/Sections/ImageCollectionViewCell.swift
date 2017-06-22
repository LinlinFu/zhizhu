//
//  ImageCollectionViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/9.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    var mainImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainImage = UIImageView()
        contentView.addSubview(mainImage)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainImage.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
    }
}
