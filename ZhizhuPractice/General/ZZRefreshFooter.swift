//
//  ZZRefreshFooter.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ZZRefreshFooter: MJRefreshAutoGifFooter {

    override func prepare() {
        
        super.prepare()

        setTitle("", for: MJRefreshState.idle)
        setTitle("正在加载更多任务", for: MJRefreshState.refreshing)
        setTitle("没有更多数据", for: MJRefreshState.noMoreData)
        
    }

}
