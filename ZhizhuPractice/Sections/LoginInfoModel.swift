//
//  LoginInfoModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation

struct LoginInfoModel {
    var name: String!
    init(json:JSON) {
        name = json["name"].stringValue
    }
}
