//
//  NewAuditRecordList.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class NewAuditRecordList: NSObject {
    //    "id": "148384123617125647",
    //    "refTable": "COMPANY_REGISTER",
    //    "refTableId": "148383554119222705",
    //    "auditUserId": "148099322967320542",
    //    "auditTime": 1483841236000,
    //    "status": 1,
    //    "comment": ""
    
    var id: String?
    var refTable: String?
    var refTableId: String?
    var auditUserId: String?
    var auditTime: String?
    var status: Int?
    var comment: String?
    
    init(json: JSON) {
        id = json["id"].stringValue
        refTable = json["refTable"].stringValue
        refTableId = json["refTableId"].stringValue
        auditUserId = json["auditUserId"].stringValue
        auditTime = json["auditTime"].stringValue
        comment = json["comment"].stringValue
        status = json["status"].intValue
    }
    
    override init() {
        super.init()
    }
    
    init(auditRecord: [String: AnyObject]) {
        super.init()
        self.id = auditRecord["id"] as? String
        self.refTable = auditRecord["refTable"] as? String
        self.refTableId = auditRecord["refTableId"] as? String
        self.auditUserId = auditRecord["auditUserId"] as? String
        self.auditTime = auditRecord["auditTime"] as? String
        self.comment = auditRecord["comment"] as? String
        if let status = auditRecord["status"] as? Int {
            self.status = status
        }

    }
    
    
    
    

}
