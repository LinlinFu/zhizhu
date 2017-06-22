//
//  LogWeekDetailModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/1.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LogWeekDetailModel: NSObject {
//    "practice": null,
//    "standards": null,
//    "weatherMorn": null,
//    "weatherAfter": null,
//    "temperature": null,
//    "id": "149608340478275063",
//    "exercitationPlanId": "148099410377169360",
//    "type": 2,
//    "description": "这周的任务基本基本都是一样的，开挖雨水管道，污水管道。下管道，接落水管，墙排。砌井，",
//    "sort": 15,
//    "createTime": 1496083404000,
//    "updateTime": 1496083404000,
//    "score": null,
//    "remarks": null,
//    "markUserId": null,
//    "markTime": null,
//    "createTimeString": null,
//    "createUserId": "148099376859633424",
//    "name": null,
//    "dailyNumber": null,
//    "weekNumber": null,
//    "readCount": null,
//    "className": null,
//    "theName": null,
//    "upPieceId": null,
//    "unPieceId": null,
//    "fileList": null,
//    "logList": null,
//    "files": null
    
    //日记/周记id
    var id: String!
    // planId
    var exercitationPlanId: String!
    // 项目进展情况/本周实践工作简述
    var descript: String!
    // 本人参与工程实践情况/本周所学工作要点
    var practice: String!
    // 设计规范标准
    var standards: String!
    //type??
    var type: Int!
    // 排序数字
    var sort: Int!
    // 创建时间
    var createTime: String!
    // 更新时间
    var updateTime: String!
    // 附件数组
    var fileList: [FileListModel] = []
    // 评分
    var score: String!
    // 评语
    var remarks: String!

    
    init(json: JSON) {
        id = json["id"].stringValue
        updateTime = json["updateTime"].stringValue
        descript = json["description"].stringValue
        practice = json["practice"].stringValue
        standards = json["standards"].stringValue
        createTime = json["createTime"].stringValue
        sort = json["sort"].intValue
        type = json["type"].intValue
        updateTime = json["updateTime"].stringValue
        score = json["score"].stringValue
        exercitationPlanId = json["exercitationPlanId"].stringValue
        remarks = json["remarks"].stringValue
        for model in json["fileList"].arrayValue {
            let model = FileListModel(json: model)
            fileList.append(model)
        }
        
    }
    


}

//"id": "149630799793040468",
//"refTable": null,
//"refTableId": null,
//"name": "149630770758050715",
//"originalName": "149630770758050715",
//"description": null,
//"fileExtension": "jpg",
//"relativePath": "/upload/other/149482941632176483/",
//"fileSize": null,
//"status": null,
//"uploadUserId": null,
//"modifyUserId": null,
//"type": null,
//"videoTime": null,
//"createTime": null,
//"modifyTime": null,
//"isConvertPreview": null,
//"md5Check": null,
//"convertPath": null

struct FileListModel {
    //
    var id: String!
    //
    var name: String!
    //
    var originalName: String!
    // 文件类型
    var fileExtension: String!
    // 相关路径
    var relativePath: String!
    
    init(json:JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        originalName = json["originalName"].stringValue
        fileExtension = json["fileExtension"].stringValue
        relativePath = json["relativePath"].stringValue
    }
}





