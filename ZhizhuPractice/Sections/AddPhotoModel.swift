//
//  AddPhotoModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/13.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AddPhotoModel: NSObject {
    var id: String!
    var url: String!
    
    init(json: JSON) {
        id = json["id"].stringValue
        url = json["url"].stringValue
    }
}
