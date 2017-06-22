//
//  FeekbackModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class FeekbackModel: NSObject {
//    "id": "148396527944428968",
//    "exercitationPlanId": "148099410377169360",
//    "createUserId": null,
//    "teacherName": "宋师傅",
//    "sex": 1,
//    "duties": "",
//    "schoolName": "",
//    "education": "研究生",
//    "mobile": "18663287399",
//    "achievements": " ",
//    "projectName": "左岸",
//    "buildingArea": "",
//    "levelNumber": "",
//    "structuralStyle": "",
//    "fitment": "",
//    "development": "",
//    "supervisionCompany": "",
//    "design": "",
//    "survey": "",
//    "projectCurrentStatus": "",
//    "projectEndStatus": "",
//    "worksiteAddress": "",
//    "houseAddress": "",
//    "description": "=-=",
//    "status": 1,
//    "auditTime": null,
//    "createTime": null,
//    "professional": null,
//    "name": null,
//    "className": null,
//    "theName": null,
//    "auditRecordList": [
//    {
//    "id": "148397080439250850",
//    "refTable": "WORKSITE_FEEDBACK",
//    "refTableId": "148396527944428968",
//    "auditUserId": "148099322967320542",
//    "auditTime": 1483970804000,
//    "status": 1,
//    "comment": ""
//    }
//    ],
//    "classId": null,
//    "upAndUnList": null,
//    "checkStatus": null,
//    "checkTime": null,
//    "userMobile": null,
//    "company": null,
//    "address": null
    
    // id 
    var id: String!
    //师傅姓名
    var teacherName: String!
    // 性别 1:男 2:女
    var sex: Int!
    // 职务
    var duties: String!
    // 毕业院校
    var schoolName: String!
    // 学历
    var education: String!
    // 手机号码
    var mobile: String!
    // 主要工作业绩
    var achievements: String!
    // 工程名称
    var projectName: String!
    //建筑面积
    var buildingArea: String!
    // 层数
    var levelNumber: String!
    // 结构形式
    var structuralStyle: String!
    // 装修
    var fitment: String!
    // 建设
    var development: String!
    // 监理
    var supervisionCompany: String!
    // 设计
    var design: String!
    // 勘察
    var survey: String!
    // 目前工程施工形象部位
    var projectCurrentStatus: String!
    // 实习结束预期形象部位
    var projectEndStatus: String!
    // 住宿地址
    var worksiteAddress: String!
    // 住宿情况
    var houseAddress: String!
    // 对实习工地以及实习任务的认识与描述
    var descript: String!
    // 审核记录
    var auditRecordList: [AuditRecordList] = []
    
    init(json: JSON) {
        id = json["id"].stringValue
        teacherName = json["teacherName"].stringValue
        sex = json["sex"].intValue
        duties = json["duties"].stringValue
        schoolName = json["schoolName"].stringValue
        education = json["education"].stringValue
        mobile = json["mobile"].stringValue
        achievements = json["achievements"].stringValue
        projectName = json["projectName"].stringValue
        buildingArea = json["buildingArea"].stringValue
        levelNumber = json["levelNumber"].stringValue
        structuralStyle = json["structuralStyle"].stringValue
        fitment = json["fitment"].stringValue
        development = json["development"].stringValue
        supervisionCompany = json["supervisionCompany"].stringValue
        design = json["design"].stringValue
        survey = json["survey"].stringValue
        projectCurrentStatus = json["projectCurrentStatus"].stringValue
        projectEndStatus = json["projectEndStatus"].stringValue
        worksiteAddress = json["worksiteAddress"].stringValue
        houseAddress = json["houseAddress"].stringValue
        descript = json["description"].stringValue
        achievements = json["achievements"].stringValue
        
        for list in json["auditRecordList"].arrayValue {
            let list = AuditRecordList(json: list)
            auditRecordList.append(list)
        }
    }

}
