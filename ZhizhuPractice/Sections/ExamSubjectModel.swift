//
//  ExamSubjectModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ExamSubjectModel: NSObject {
//    "id": "148349355977693930",
//    "userId": null,
//    "title": "开关箱内电器临时发生断线或保险丝断线，（   ）。",
//    "type": 1,
//    "createTime": 1483493559000,
//    "updateTime": null,
//    "status": null,
//    "userIsRight": null,
//    "list": [

//    ],
//    "userChooseOptions": null,
//    "selectedOptionIds": null,
//    "optionList": null,
//    "rightOptin": null,
//    "paperId": null,
//    "only": null,
//    "more": null,
//    "judge": null,
//    "checkStatus": null,
//    "checkTime": null,
//    "subjectName": null
//}
    
    //题目id
    var id: String!
    // 题目内容
    var title: String!
    // 题目类型 type
    var type: String!
    // 答题者答案
    var userIsRight: String!
    //
    var list: [ExamListModel] = []
    // 总成绩
    var totalCount: String!
    // 已经选择的选项
    var selectedOptionIds: String!
    // 自己添加的标志属性
    var flag: Int!
    
    
    
    init(json:JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue
        type = json["type"].stringValue
        userIsRight = json["userIsRight"].stringValue
        totalCount = json["totalCount"].stringValue
        selectedOptionIds = json["selectedOptionIds"].stringValue
        flag = 10
        for model in json["list"].arrayValue {
            let data = ExamListModel(json: model)
            list.append(data)
        }
    }

    

    
}

struct ExamListModel {
    //    "id": "148349355977726749",
    //    "subjectId": "148349355977693930",
    //    "item": "D",
    //    "content": "可以找施工员来接",
    //    "isRight": 0,
    //    "createTime": null,
    //    "isUserChoose": 0
    
    // 答案选项的id
    var id: String!
    // 题目id
    var subjectId: String!
    // 选项号
    var item: String!
    // 选项内容
    var content: String!
    // 是否是正确答案
    var isRight: Bool!
    // 是否被选择
    var isUserChoose: Bool!
    
    init(json:JSON) {
        id = json["id"].stringValue
        subjectId = json["subjectId"].stringValue
        item = json["item"].stringValue
        content = json["content"].stringValue
        isRight = json["isRight"].boolValue
        isUserChoose = json["isUserChoose"].boolValue
    }
    
    
    
}









