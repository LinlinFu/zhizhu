//
//  AttendanceDetailModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/1.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AttendanceDetailModel: NSObject {
    
//    "id": "149627943488447936",
//    "exercitationPlanId": "149482893428792725",
//    "createUserId": "149482941632176483",
//    "attendanceTime": 1496279434000,
//    "attendanceAddress": "浙江省杭州市滨江区建业路511",
//    "attendanceLatitude": "30.19418,120.187514",
//    "attendanceStatus": 1,
//    "startTime": null,
//    "endTime": null,
//    "schoolId": null,
//    "classId": null,
//    "signed": 0,
//    "unSigned": 0,
//    "errorSigned": 0,
//    "noCount": null,
//    "signeTime": null,
//    "name": null,
//    "searchDays": null,
//    "dateTime": null,
//    "alreadyCount": null
    
    // planId
    var exercitationPlanId: String!
    // 签到记录id
    var id: String!
    // userId
    var createUserId: String!
    // 出勤时间(时间戳形式)
    var attendanceTime: String!
    // 出勤地址
    var attendanceAddress: String!
    // 出勤经纬度
    var attendanceLatitude: String!
    // 出勤状态  1:已出勤
    var attendanceStatus: Int!
    
    init(json:JSON) {
        exercitationPlanId = json["exercitationPlanId"].stringValue
        id = json["id"].stringValue
        createUserId = json["createUserId"].stringValue
        attendanceTime = json["attendanceTime"].stringValue
        attendanceAddress = json["attendanceAddress"].stringValue
        attendanceLatitude = json["attendanceLatitude"].stringValue
        attendanceStatus = json["attendanceStatus"].intValue
    }
    
    
}
