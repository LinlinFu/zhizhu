//
//  GradesModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/7.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class GradesModel: NSObject {
//    "attendScore": 0,
//    "finalScore": 0,
//    "missionScore": 0,
//    "sumScore": 0,
//    "midScore": 0,
//    "dayScore": 0,
//    "weekScore": 0
    
    // 签到得分
    var attendScore: Int!
    // 日志得分
    var dayScore: Int!
    // 周记得分
    var weekScore: Int!
    // 任务得分
    var missionScore: Int!
    // 中期得分
    var midScore: Int!
    // 总结得分
    var finalScore: Int!
    
    init(json:JSON) {
        attendScore = json["attendScore"].intValue
        dayScore = json["dayScore"].intValue
        weekScore = json["weekScore"].intValue
        missionScore = json["missionScore"].intValue
        midScore = json["midScore"].intValue
        finalScore = json["finalScore"].intValue
    }
    
    
}
