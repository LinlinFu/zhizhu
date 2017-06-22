//
//  RemindModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class RemindModel: NSObject {

//    "sendUserType": 2,
//    "id": "149371470297730724",
//    "title": "您的日报已被批阅！",
//    "content": "您的日报已被批阅，获得分数【95】，评语【写得不错，继续加油！】",
//    "sendUserId": "1",
//    "sendUserNickname": "系统通知",
//    "receiveUserGroup": 0,
//    "status": 1,
//    "startTime": 1493714702000,
//    "endTime": null,
//    "createTime": 1493714702000,
//    "updateTime": null,
//    "isTiming": null,
//    "exercitationPlanId": null,
//    "type": null,
//    "photoUrl": null,
//    "receiveId": "149371470297755208",
//    "schoolId": null,
//    "selected": false
    
    
    // 通知类型文本
    var sendUserNickname: String!
    // 通知简短内容
    var title: String!
    // 通知id
    var id: String!
    // 通知详情
    var content: String!
    // 开始时间
    var createTime: String!
    // 是否查看过
    var selected: Bool!
    // 接受id
    var receiveId: String!
    
    init(json: JSON) {
        sendUserNickname = json["sendUserNickname"].stringValue
        title = json["title"].stringValue
        id = json["id"].stringValue
        content = json["content"].stringValue
        createTime = json["createTime"].stringValue
        selected = json["selected"].boolValue
        receiveId = json["receiveId"].stringValue
    }
    
    
}
