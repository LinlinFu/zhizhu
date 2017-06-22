//
//  TaskApplyListModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskApplyListModel: NSObject {
//    "resultObject": [
//    {
//    "id": "147497792104971862",
//    "exercitationPlanId": null,
//    "createUserId": null,
//    "exercitationMissionId": "147497774861499680",
//    "startTime": 1474905600000,
//    "endTime": 1475596800000,
//    "requirementContent": null,
//    "considerPreparation": null,
//    "status": 1,
//    "auditTime": null,
//    "createTime": null,
//    "submitStatus": 1,
//    "numbering": null,
//    "impSubmitStatus": null,
//    "missionName": null,
//    "name": "的顶顶顶顶顶大",
//    "theName": null,
//    "className": null,
//    "count": null,
//    "count1": null,
//    "count2": null,
//    "count3": null,
//    "count4": null,
//    "comment": null,
//    "approvalStatus": null,
//    "approvalTime": null,
//    "approvalScore": null,
//    "impId": null,
//    "score": "66",
//    "compendiumList": [ ],
//    "fileList": [ ],
//    "description": null
    //    }
//    ]
    
    // 任务名称
    var name: String!
    // 开始时间
    var startTime: String!
    // 结束时间
    var endTime: String!
    // 任务id
    var exercitationMissionId: String!
    // 审核状态(0 未审核 -2 未通过 1通过)
    var status: Int!
    // id
    var id: String!
    
    init(json:JSON) {
        name = json["name"].stringValue
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
        exercitationMissionId = json["exercitationMissionId"].stringValue
        id = json["id"].stringValue
        status = json["status"].intValue
    }
    
    
}
