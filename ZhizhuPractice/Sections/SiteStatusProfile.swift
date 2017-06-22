//
//  SiteStatusProfile.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
public enum PropertyIntType: String {
    // 身高
    case Height = "height"
    // 体重
    case Weight = "weight"
    // 婚姻状况
    case Married = "married"
    // 是否孩子
    case HasChildren = "hasChildren"
    // 是否怀孕
    case IsPregnant = "isPregnant"
    // 是否存在犯罪记录
    case AnyCrimeBehavior = "anyCrimeBehavior"
    // 是否签订禁业合同
    case HasLimitContract = "hasLimitContract"
}

class SiteStatusProfile: NSObject {
    // id
    var id: String?
    //师傅姓名
    var teacherName: String?
    // 性别 1:男 2:女
    var sex: Int?
    // 职务
    var duties: String?
    // 毕业院校
    var schoolName: String?
    // 学历
    var education: String?
    // 手机号码
    var mobile: String?
    // 主要工作业绩
    var achievements: String?
    // 工程名称
    var projectName: String?
    //建筑面积
    var buildingArea: String?
    // 层数
    var levelNumber: String?
    // 结构形式
    var structuralStyle: String?
    // 装修
    var fitment: String?
    // 建设
    var development: String?
    // 监理
    var supervisionCompany: String?
    // 设计
    var design: String?
    // 勘察
    var survey: String?
    // 目前工程施工形象部位
    var projectCurrentStatus: String?
    // 实习结束预期形象部位
    var projectEndStatus: String?
    // 住宿地址
    var worksiteAddress: String?
    // 住宿情况
    var houseAddress: String?
    // 对实习工地以及实习任务的认识与描述
    var descript: String?
    // 审核记录
    var auditRecordLists: [NewAuditRecordList]?
    
    
    init(info: [String: AnyObject]?) {
        super.init()
        guard let materialInfo = info?["resultObject"] as? [String: AnyObject] else {
            return
        }
        
        self.id = materialInfo["id"] as? String
        self.teacherName = materialInfo["teacherName"] as? String
        self.duties = materialInfo["duties"] as? String
        self.schoolName = materialInfo["schoolName"] as? String
        self.education = materialInfo["education"] as? String
        self.mobile = materialInfo["mobile"] as? String
        self.achievements = materialInfo["achievements"] as? String
        self.projectName = materialInfo["projectName"] as? String
        self.buildingArea = materialInfo["buildingArea"] as? String
        self.levelNumber = materialInfo["levelNumber"] as? String
        self.structuralStyle = materialInfo["structuralStyle"] as? String
        self.fitment = materialInfo["fitment"] as? String
        self.development = materialInfo["development"] as? String
        self.supervisionCompany = materialInfo["supervisionCompany"] as? String
        self.design = materialInfo["design"] as? String
        self.survey = materialInfo["survey"] as? String
        self.projectCurrentStatus = materialInfo["projectCurrentStatus"] as? String
        self.worksiteAddress = materialInfo["worksiteAddress"] as? String
        self.houseAddress = materialInfo["houseAddress"] as? String
        self.descript = materialInfo["descript"] as? String
        self.achievements = materialInfo["achievements"] as? String
        if let sex = materialInfo["sex"] as? Int {
            self.sex = sex
        }

        if let auditRecordList = materialInfo["auditRecordList"] as? [[String: AnyObject]], auditRecordList.count > 0 {
            auditRecordLists = [NewAuditRecordList]()
            for auditRecordList in auditRecordList {
                let workExperience = NewAuditRecordList(auditRecord: auditRecordList)
                auditRecordLists?.append(workExperience)
            }
        }

        
    }
    
}
