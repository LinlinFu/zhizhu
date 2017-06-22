//
//  ZZHelper.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
/**
 *  全局帮助类
 */
struct ZZHelper {
    
    
    var uploadURL: String {
        return ZZHelper.isDevEvironment() ? ZZDevUpload : ZZDisUpload
    }
    
    //MARK: 自动登出
    static func userLogout() {
        
//        ServerProvider<AccountServer>().requestReturnDictionary(target: .logout()) { (success, info) in
//            guard let info = info else {
//                let vc = RemindViewController(title: "网络异常", type: .failure)
//                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                return
//            }
//            let status = JSON(info)["status"].intValue
//            if success && status == 200 {
//                clearUserData()
//            } else {
//                let vc = RemindViewController(title: "登出失败")
//                UIApplication.shared.keyWindow?.rootViewController!.present(vc, animated: true, completion: nil)
//            }
//        }
//
      
    }
    
    //MARK: 清除用户信息
    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: AppKeys.UserName)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserTel)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserClassId)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserId)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserSchoolId)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserSchoolName)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserphotoUrl)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserToken)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserNickName)
        UserDefaults.standard.removeObject(forKey: AppKeys.UserRealName)
        UserDefaults.standard.removeObject(forKey: AppKeys.PlanId)
        UserDefaults.standard.removeObject(forKey: AppKeys.NetworkStatus)
        UserDefaults.standard.removeObject(forKey: AppKeys.PlanName)
        UserDefaults.standard.removeObject(forKey: AppKeys.CurrentStage)
        
        NotificationCenter.default.post(name: AppNoti.CheckLoginState, object: nil)
    }
    
    //MARK: 是否为测试环境
    static func isDevEvironment() -> Bool {
        return UserDefaults.standard.bool(forKey: AppKeys.isDev)
    }
    
    //MARK: 是否允许非Wi-Fi网络下载/上传
    static func isAllowNotWiFi() -> Bool {
        return UserDefaults.standard.bool(forKey: AppKeys.NetworkStatus)
    }
    
    //MARK: MD5?????????
//    static func md5(string: String) -> String {
//        let str = string.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize()
//        
//        return String(format: hash as String)
//    }
    
    //MARK:时间戳装换
    // 时间格式转换
    static func timeFormat(timeStamp: String, format: String) -> String {
        if timeStamp == "" {
            return ""
        }
        guard !timeStamp.isEmpty && !format.isEmpty else { return "" }
        
        let interval = (timeStamp as NSString).doubleValue / 1000.0
        let date = Date.init(timeIntervalSince1970: interval)
        
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let finalTimeStamp = outputFormat.string(from: date)
        
        let tempTime = finalTimeStamp.substring(to: finalTimeStamp.index(finalTimeStamp.startIndex, offsetBy: Int(19))).replacingOccurrences(of: "T", with: " ")
        guard let finaldate = outputFormat.date(from: tempTime) else {
            return ""
        }
        outputFormat.dateFormat = format
        return outputFormat.string(from: finaldate)
    }
    
    
    // String类型的时间转为时间戳
    static func stringToTimeStamp(stringTime:String, format: String)->String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        let date = dfmatter.date(from: stringTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
        
    }
    
    // Date转为时间戳
    static func dateToTimeStamp(date:Date)->String {
        let dateStamp:TimeInterval = date.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return String(dateSt)
        
    }


}
