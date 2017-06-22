//
//  PlanTimeModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PlanTimeModel: NSObject {
//    resultObject": {
//    "id": "149482893432435432",
//    "exercitationPlanId": "149482893428792725",
//    "type": "CONDUCT_TIME",
//    "startTime": 1494950400000,
//    "endTime": 1515081600000
//}
    
    var exercitationPlanId: String!
    var type: String!
    var startTime: String!
    var endTime: String!
    
    init(json: JSON) {
        exercitationPlanId = json["exercitationPlanId"].stringValue
        type = json["type"].stringValue
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
    }
}
