//
//  TaskDetailModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskDetailModel: NSObject {
//    "id": "147497611688856833",
//    "exercitationPlanId": "147495431082857377",
//    "createUserId": null,
//    "exercitationMissionId": "147494207143055471",
//    "startTime": 1474905600000,
//    "endTime": 1475596800000,
//    "requirementContent": "法规及规及安防记得加上富家大室分几点上课就风口浪尖的萨克拉加粉快来得及撒可率就放开劳动竞赛开发法规及安防",
//    "considerPreparation": "法规及安开发法规及安防记得加上富家大室分几点上课就风口浪尖的萨克拉加粉快来得及撒可率就放开劳动竞赛开发法规及安防",
//    "status": 0,
//    "auditTime": null,
//    "createTime": null,
//    "submitStatus": 1,
//    "numbering": null,
//    "impSubmitStatus": null,
//    "missionName": null,
//    "name": "执行命令服务",
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
//    "score": null,
//    "compendiumList": [
//    {
//    "id": null,
//    "exercitationMissionDeclareId": null,
//    "description": "发的萨发发的发的萨发发的发的萨发发的发的萨发发的",
//    "sort": 1
//    },
//    {
//    "id": null,
//    "exercitationMissionDeclareId": null,
//    "description": "发的萨发发的发的萨发发的发的萨发发的发的萨发发的",
//    "sort": 2
//    },
//    {
//    "id": null,
//    "exercitationMissionDeclareId": null,
//    "description": "发的萨发发的发的萨发发的发的萨发发的发的萨发发的",
//    "sort": 3
//    }
//    ],
//    "fileList": [ ],
//    "description": "严格执行计划"
    
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
    // 任务描述
    var descript: String!
    // 师傅要求摘要
    var requirementContent: String!
    // 思考准备
    var considerPreparation: String!
    // 工作提纲
    var compendiumList: [CompendiumList] = []
    // 任务附件
    var fileList: [FileList] = []
    
    init(json:JSON) {
        name = json["name"].stringValue
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
        exercitationMissionId = json["exercitationMissionId"].stringValue
        id = json["id"].stringValue
        status = json["status"].intValue
        descript = json["description"].stringValue
        requirementContent = json["requirementContent"].stringValue
        considerPreparation = json["considerPreparation"].stringValue
        for data in json["compendiumList"].arrayValue {
            let model = CompendiumList(json: data)
            compendiumList.append(model)
        }
        for data in json["fileList"].arrayValue {
            let model = FileList(json: data)
            fileList.append(model)
        }

    }
    

}


// 工作提纲
struct CompendiumList {
    //    "id": null,
    //    "exercitationMissionDeclareId": null,
    //    "description": "发的萨发发的发的萨发发的发的萨发发的发的萨发发的",
    //    "sort": 3
    
    var id: String!
    var descript: String!
    // 序号
    var sort: Int!
    
    init(json:JSON) {
        id = json["id"].stringValue
        descript = json["description"].stringValue
        sort = json["sort"].intValue
    }

}
