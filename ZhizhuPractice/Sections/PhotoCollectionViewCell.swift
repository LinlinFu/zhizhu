//
//  PhotoCollectionViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/12.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit



class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    var tapBlock:(()->())? = nil
    
    // MARK:
    func updateData(model: FileListModel, canEdit: Bool) {
        if canEdit {
            deleteIcon.isHidden = false
        } else {
            deleteIcon.isHidden = true
        }
        
        let urlString = "\(ZZHelper().uploadURL)\(model.relativePath!)\(model.name!)" + ".\(model.fileExtension!)"
        print(urlString)
        mainImage.kf_setImageWithURL(URL: URL(string: urlString), placeholderImage: UIImage())
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteAction))
        deleteIcon.addGestureRecognizer(tap)
        deleteIcon.isUserInteractionEnabled = true
    }
    
    //MARK: deleteAction
    func deleteAction() {
        tapBlock!()
    }

}
