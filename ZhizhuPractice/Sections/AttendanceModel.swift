//
//  AttendanceModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/6.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AttendanceModel: NSObject {
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
    
    // 记录id
    var id: String!
    // 出勤时间
    var attendanceTime: String!
    // 出勤地点
    var attendanceAddress: String!
    // 出勤经纬度
    var attendanceLatitude: String!
    
    init(json:JSON) {
        id = json["id"].stringValue
        attendanceTime = json["attendanceTime"].stringValue
        attendanceAddress = json["attendanceAddress"].stringValue
        attendanceLatitude = json["attendanceLatitude"].stringValue
    }
    
    
}
