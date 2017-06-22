//
//  MaterialJumpType.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
public enum SelectJumpType: Int {
    /// 日期选择
    case Date = 0
    /// 婚姻状态选择
    case MaritalStatus = 1
    /// 籍贯选择
    case NativePlace = 2
    /// 户籍类型选择
    case Household = 3
    /// 家属关系选择
    case Kinship = 4
    /// 身体健康状况选择
    case HealthCondition = 5
    /// 学历选择
    case Education = 6
    /// 学位选择
    case Degree = 7
    /// 学制选择
    case EducationalSystem = 8
    /// 应聘岗位选择
    case ApplyPost = 9
    /// 关注焦点
    case Concern = 10
    /// 工作区域
    case WorkRegion = 11
}

class MaterialJumpType: NSObject {
    internal class func resolveJumpType(content: String?) -> SelectJumpType {
        guard let text = content else {
            return .Date
        }
        switch text {
        case "出生年月", "起始时间", "结束时间":
            return .Date
        case "第一位", "第二位", "第三位":
            return .Concern
        case "婚姻状况":
            return .MaritalStatus
        case "籍贯":
            return .NativePlace
        case "户籍类型":
            return .Household
        case "选择关系":
            return .Kinship
        case "身体健康状态":
            return .HealthCondition
        case "学历":
            return .Education
        case "学位":
            return .Degree
        case "学制":
            return .EducationalSystem
        case "应聘岗位":
            return .ApplyPost
        case "工作区域":
            return .WorkRegion
        default:
            return .Date
        }
    }
    internal class func getselectedData(jumpType: SelectJumpType) -> [String]? {
        switch jumpType {
        case .MaritalStatus:
            return ["已婚已育", "已婚未育", "未婚"]
        case .Household:
            return ["农村", "城镇"]
        case .Education:
            return ["初中以及下", "高中", "大专", "本科", "硕士"]
        case .Degree:
            return ["学士", "硕士", "博士"]
        case .EducationalSystem:
            return ["全日制", "函授", "远程教育"]
        case .Kinship:
            return ["父亲", "母亲", "儿子", "女儿"]
        case .HealthCondition:
            return ["强壮", "健康", "体质偏弱"]
        default:
            return nil
        }
    }
    
    internal class func selectedSikpNewViewController(context: NewSiteStatusFeedbackViewController,
                                                      content: String?,
                                                      indexPath: NSIndexPath,
                                                      superSection: Int?) {
        let type = resolveJumpType(content: content)
        if type == .Date {
            context.selectDateForIndexPath(indexPath: indexPath, content: content!, superSection: superSection)
        } else {
            let materialChoiceVC = MaterialChoiceViewController()
            materialChoiceVC.selectType = type
            materialChoiceVC.naviTitle = content
            materialChoiceVC.preIndexPath = indexPath
            materialChoiceVC.delegate = context
            materialChoiceVC.superSection = superSection
            context.navigationController?.pushViewController(materialChoiceVC, animated: true)
        }
    }
    
    internal class func getJumpType(content: String?) -> SelectJumpType {
        return resolveJumpType(content: content)
    }
}
