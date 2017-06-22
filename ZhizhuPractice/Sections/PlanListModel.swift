//
//  PlanListModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/31.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PlanListModel: NSObject {

    
    //status:0 进行中
    var createUserId: String
    var exercitationPlanId: String
    var status: Int
    var planName: String
    
    
    init(json:JSON) {
        createUserId = json["createUserId"].stringValue
        exercitationPlanId = json["exercitationPlanId"].stringValue
        status = json["status"].intValue
        planName = json["planName"].stringValue
    }
}
