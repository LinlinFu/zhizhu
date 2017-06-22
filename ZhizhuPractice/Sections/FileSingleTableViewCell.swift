//
//  FileSingleTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/9.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class FileSingleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var dataArray: [FileList] = [] {
        willSet {
            collectionView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize(width: (ZZScreenWidth - 70) / 5, height: 60)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FileSingleTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.mainImage.image = UIImage(named: "fileHolder")
        return cell
    }
}
