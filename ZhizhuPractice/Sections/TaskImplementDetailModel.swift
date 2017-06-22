//
//  TaskImplementDetailModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskImplementDetailModel: NSObject {
//    "id": "147504191539773015",
//    "exercitationMissionDeclareId": "147497792104971862",
//    "collectMaterial": "vcxzvcxv",
//    "learnMaterial": "范德萨",
//    "missionMaterial": "范德萨",
//    "createTime": 1475041915000,
//    "createUserId": "147495416355046356",
//    "markTime": 1475042117000,
//    "score": 66,
//    "markUserId": "147495412461464859",
//    "remarks": "写得不错，继续加油！",
//    "submitStatus": 1,
//    "count": null,
//    "count1": null,
//    "count2": null,
//    "count3": null,
//    "count4": null,
//    "count5": null,
//    "name": null,
//    "startTime": null,
//    "exercitationPlanId": null,
//    "fileList": [],
//    "endTime": null,
//    "status": null
    
    // 搜集资料 对照学习
    var collectMaterial: String!
    // 跟踪模仿 学习理解
    var learnMaterial: String!
    // 任务实施
    var missionMaterial: String!
    // 附件
    var fileList: [FileList] = []
    // 教师点评-评语
    var remarks: String!
    // 教师点评-评分
    var score: String!
    // 提交状态 1:已完成
    var submitStatus: Int!
    
    init(json:JSON) {
        collectMaterial = json["collectMaterial"].stringValue
        learnMaterial = json["learnMaterial"].stringValue
        missionMaterial = json["missionMaterial"].stringValue
        remarks = json["remarks"].stringValue
        score = json["score"].stringValue
        submitStatus = json["submitStatus"].intValue

        for data in json["fileList"].arrayValue {
            let model = FileList(json: data)
            fileList.append(model)
        }
        
    }
    
    
    

    
}
