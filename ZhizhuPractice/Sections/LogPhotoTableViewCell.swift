//
//  LogPhotoTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/12.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LogPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //添加图片
    var uploadPhotoBlock:(()->())? = nil
    // 删除图片
    var deleteBolck:((_ row: Int)->())? = nil
    
    var dataArray: [FileListModel] = [] {
        willSet {
            collectionView.reloadData()
        }
    }
    
    // 是否可以修改
    var canEdit = false
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = (ZZScreenWidth - 70) / 5.0
        flowLayout.itemSize = CGSize(width: width, height: width)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension LogPhotoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if canEdit {
                return dataArray.count + 1
            }
        return dataArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PhotoCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        if !canEdit {
            cell.updateData(model:dataArray[indexPath.row], canEdit:canEdit)
        } else {
            
            
            if indexPath.row == dataArray.count {
                cell.mainImage.image = UIImage(named: "add_photo")
                cell.deleteIcon.isHidden = true
            } else {
                
                cell.updateData(model:dataArray[indexPath.row], canEdit:canEdit)
            }
        }
        cell.tapBlock = {()-> Void in
            self.deleteBolck?(indexPath.row)
        
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !canEdit {
            return
        }
        // 添加照片
        if indexPath.row == dataArray.count {
            self.uploadPhotoBlock?()
        }
    }
    

}
