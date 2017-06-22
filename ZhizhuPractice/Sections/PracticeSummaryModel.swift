//
//  PracticeSummaryModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/7.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

/////// 中期汇报 实习总结
class PracticeSummaryModel: NSObject {
    // 汇报内容
    var summary: Summary!
    // 文件
    var fileList: [FileList] = []
    //
    var isCurUser: Bool!
    var hasSummary: Bool!
    
    init(json: JSON) {
        summary = Summary(json: json["summary"])
        for model in json["fileList"].arrayValue {
            let model = FileList(json: model)
            fileList.append(model)
        }
        isCurUser = json["isCurUser"].boolValue
        hasSummary = json["hasSummary"].boolValue
    }
}


struct Summary {
    //    "id": "148940964089686228",
    //    "exercitationPlanId": null,
    //    "type": 1,
    //    "createTime": null,
    //    "score": null,
    //    "remarks": null,
    //    "markUserId": null,
    //    "markTime": null,
    //    "createUserId": "148099376859633424",
    //    "description": "深入工地现场，与现场的工人和技术人员进行面对面的交流与指导，参与实践，全面系统的了解建筑工程的各项施工技术与施工工艺，以及各项管理措施。熟悉工程建设企业的性质、作业特点，以及生产管理的经营运作模式。在现场施工过程中结合所学专业知识与实际现场工作进行整合，强化专业知识和技巧的运用和实务工作的能力;增强理论联系实际的观念，培养分析问题和解决问题的能力，加强专业意识和职业责任感，为施工管理起到了实质性的指导作用，为以后的工作打下坚实的理论与实践基础。",
    //    "endTime": 1489593600000,
    //    "state": 0
    
    var id: String!
    var score: String!
    var remarks: String!
    var descript: String!
    var state: Int!
    
    init(json:JSON) {
        id = json["id"].stringValue
        score = json["score"].stringValue
        remarks = json["remarks"].stringValue
        descript = json["description"].stringValue
        state = json["state"].intValue
    }
}

struct FileList {
    //    "id": "148940964095448608",
    //    "refTable": "SUMMARY_FILE",
    //    "refTableId": "148940964089686228",
    //    "name": "o1bb3rphk6u1b1gdj15378sc1dnr7",
    //    "originalName": "midSummary",
    //    "description": null,
    //    "fileExtension": "doc",
    //    "relativePath": "/upload/file/exercitation/148099376859633424/",
    //    "fileSize": "16896",
    //    "status": null,
    //    "uploadUserId": null,
    //    "modifyUserId": null,
    //    "type": 0,
    //    "videoTime": null,
    //    "createTime": 1489409640000,
    //    "modifyTime": null,
    //    "isConvertPreview": null,
    //    "md5Check": null,
    //    "convertPath": null
    
    var id: String!
    var refTable: String!
    var refTableId: String!
    var name: String!
    var fileExtension: String!
    var originalName: String!
    var relativePath: String!
    var fileSize: String!
    
    
    init(json:JSON) {
        id = json["id"].stringValue
        refTable = json["refTable"].stringValue
        refTableId = json["refTableId"].stringValue
        name = json["name"].stringValue
        fileExtension = json["fileExtension"].stringValue
        originalName = json["originalName"].stringValue
        relativePath = json["relativePath"].stringValue
        fileSize = json["fileSize"].stringValue
        
    }

    
}
