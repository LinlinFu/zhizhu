//
//  AppKeys.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation

struct AppKeys {
    static let UserToken = "ZZUserToken"
    static let isDev = "ZZDevEvironment"
    static let UserTel = "ZZUserTel"
    // 账号
    static let UserName = "ZZUserName"
    // 真实姓名
    static let UserRealName = "ZZRealName"
    static let UserClassId = "ZZUserClassId"
    static let UserId = "ZZUserId"
    static let UserNickName = "ZZUserNickName"
    static let UserSchoolId = "ZZUserSchoolId"
    static let UserSchoolName = "ZZUserSchoolName"
    static let UserphotoUrl = "ZZUserphotoUrl"
    
    static let PlanId = "PlanId"
    static let PlanName = "PlanName"
    // 当前阶段
    static let CurrentStage = "CurrentStage"
    // 允许非wifi下载
    static let NetworkStatus = "NetworkStatus"
    
    
    static func getUserToken() -> String {
        return UserDefaults.standard.object(forKey: UserToken) as? String ?? ""
    }
    
    static func getUserTel() -> String {
        return UserDefaults.standard.object(forKey: UserTel) as? String ?? ""
    }
    
    static func getUserName() -> String {
        return UserDefaults.standard.object(forKey: UserName) as? String ?? ""
    }
    
    static func getUserNickName() -> String {
        return UserDefaults.standard.object(forKey: UserNickName) as? String ?? ""
    }
    
    static func getUserId() -> String {
        return UserDefaults.standard.object(forKey: UserId) as? String ?? ""
    }
    
    static func getUserRealName() -> String {
        return UserDefaults.standard.object(forKey: UserRealName) as? String ?? ""
    }
    
    static func getUserClassId() -> String {
        return UserDefaults.standard.object(forKey: UserClassId) as? String ?? ""
    }
    
    static func getUserSchoolId() -> String {
        return UserDefaults.standard.object(forKey: UserSchoolId) as? String ?? ""
    }
    
    static func getUserSchoolName() -> String {
        return UserDefaults.standard.object(forKey: UserSchoolName) as? String ?? ""
    }
    
    static func getUserphotoUrl() -> String {
        return UserDefaults.standard.object(forKey: UserphotoUrl) as? String ?? ""
    }
    
    static func getPlanId() -> String {
        return UserDefaults.standard.object(forKey: PlanId) as? String ?? ""
    }
    
    static func getPlanName() -> String {
        return UserDefaults.standard.object(forKey: PlanName) as? String ?? ""
    }
    
    static func getCurrentStage() -> String {
        return UserDefaults.standard.object(forKey: CurrentStage) as? String ?? ""
    }
    
}
