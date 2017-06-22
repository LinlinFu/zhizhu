//
//  SiteStatusProfile+Extension.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

extension SiteStatusProfile {

    // 使用kvc赋值错误的时候回调
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "nativeProvince_nativeCity" {
            guard let text = value as? String else {
                return
            }
            let tag = text.components(separatedBy: "-")
            if tag.count == 2 {
                setValue(tag[0], forUndefinedKey: "nativeProvince")
                setValue(tag[1], forUndefinedKey: "nativeCity")
            }
        }
    }
    
    // MARK: - 数据呈现，Mode -> 视图

    
//    // 获取扩展视图个数
//    internal func getExpandCountForServer(type: PlistType) -> Int {
//        switch type {
//        case .PersonalMaterial:
//            guard let familyMembers = self.familyMembers else {
//                return 0
//            }
//            return familyMembers.count
//        case .ExperienceMaterial:
//            guard let workExperiences = self.workExperiences else {
//                return 0
//            }
//            return workExperiences.count
//        case .EducationMaterial:
//            guard let educationExperiences = self.educationExperiences else {
//                return 0
//            }
//            return educationExperiences.count
//        case .WorkExperience:
//            guard let workExperiences = self.workExperiences else {
//                return 0
//            }
//            return workExperiences.count
//        case .FamilyMembers:
//            guard let familyMembers = self.familyMembers else {
//                return 0
//            }
//            return familyMembers.count
//        default:
//            return 0
//        }
//    }

    
    // 获取值
    internal func getValueForAssginKey(keyName: AnyObject?) -> String {
        
        guard let key = keyName else {
            return ""
        }
        if let keyString = key as? String {
            var attributeValue: AnyObject?
            switch keyString {
            case "empty":
                return ""
            default:
                attributeValue = value(forKey: keyString) as AnyObject
                return dealValue(attributeValue: attributeValue, keyName: keyString)
                
            }
        }
        if let keyArray = key as? [String] {
            var valueResult = ""
            for (index, itemKey) in keyArray.enumerated() {
                let attrValue = value(forKey: itemKey)
                let valueItem =  dealValue(attributeValue: attrValue as AnyObject, keyName: itemKey)
                valueResult += valueItem
                if index == 0 && valueItem.characters.count > 0 {
                    valueResult += "-"
                }
            }
            return valueResult
        }
        return ""
    }

    
    internal func dealValue(attributeValue: AnyObject?, keyName: String) -> String {
        if let intValue = attributeValue as? Int {
            return getPropertyValue(property: intValue as AnyObject, type: PropertyIntType(rawValue: keyName))
        }
        if let stringValue = attributeValue as? String {
            return getPropertyValue(property: stringValue as AnyObject, type: nil)
        }
        return ""
    }

    // 将属性解包
    func getPropertyValue(property: AnyObject?, type: PropertyIntType? = nil) -> String {
        
        if let text = property as? String {
            return text
        }
        if let text = property as? Int {
            switch type! {
            // 身高、体重
            case .Height, .Weight:
                return "\(text)"
            // 婚姻状况
            case .Married:
                return getMarriedState(state: text)
            // 是否孩子
            case .HasChildren:
                return text == 1 ? "有" : "无"
            // 是否怀孕、是否存在犯罪记录、是否签订禁业合同
            case .IsPregnant, .AnyCrimeBehavior, .HasLimitContract:
                return text == 1 ? "是" : "否"
            }
        }
        return ""
    }
    
    func getMarriedState(state: Int) -> String {
        switch state {
        case 0:
            return "未婚"
        case 1:
            return "已婚未育"
        case 2:
            return "已婚已育"
        default:
            return ""
        }
    }

    // 将文字解析成属性值
    internal static func parsePropertValue(text: String) -> Int {
        switch text {
        case "无", "否", "未婚":
            return 0
        case "有", "是", "已婚未育":
            return 1
        case "已婚已育":
            return 2
        default:
            return 0
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
