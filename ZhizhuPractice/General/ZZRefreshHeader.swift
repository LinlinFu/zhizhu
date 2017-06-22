//
//  ZZRefreshHeader.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ZZRefreshHeader: MJRefreshGifHeader {

    override func prepare() {
        
        super.prepare()
        stateLabel.isHidden = false
        lastUpdatedTimeLabel.isHidden = true
        
            setTitle("下拉刷新", for: .idle)
            setTitle("", for: .pulling)
            setTitle("正在刷新", for: .refreshing)
//        var loadingArr: [UIImage] = [UIImage]()
//        
//        for i in 1...6 {
//            let image = UIImage(named: "refreshing_\(i)")
//            loadingArr.append(image!)
//        }
//        
//        setImages([loadingArr[5]], for: .idle)
//        setImages(loadingArr, duration: 3, for: .refreshing)
//        stateLabel.isHidden = true
        // 为了显示在中间
//        lastUpdatedTimeLabel.isHidden = true
        
    }


}
