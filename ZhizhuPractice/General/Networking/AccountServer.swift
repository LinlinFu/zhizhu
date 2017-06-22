//
//  AccountServer.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
import Alamofire


enum AccountServer {
    // 登录
    case login(username: String, password: String)
    // 发送验证码
    // codeType: 验证码类型'FORGOTPASSWORD'(忘记密码)'MODIFYPHONE'(原手机验证码，修改手机)'CONFIRMMODIFYPHONE'（新手机验证码,确认修改手机）
    case sendCode(param: [String: AnyObject])
    // 校验验证码
    case sureCode(param: [String: AnyObject])
    // 修改密码(找回密码) telephone oldPassword(找回不需要)  newPassword type(修改2 找回1) 
    case updatePassowrd(param: [String: AnyObject])
    // 上传头像
    case updateUserPhoto(name: Data, refRelationCategory: String)
    // 获取头像信息
    case getUserPhoto(photoUrl: String)
    

}


extension AccountServer:TargetType {
    var method: HTTPMethod {
        switch self {
        case .login, .updatePassowrd, .sendCode, .sureCode, .updateUserPhoto:
            return .post
        case .getUserPhoto:
            return .get
        }
    }
    
    var path: URLConvertible {
        switch self {
        case .login:
            return baseURL + "/login/studentLogin"
        case .updatePassowrd:
            return baseURL + "/student/student/updatePassowrd"
        case .sendCode:
            return baseURL + "/student/student/sendCode"
        case .sureCode:
            return baseURL + "/student/student/verifyCode"
        case .updateUserPhoto:
            return "http://upload.zz-w.cn/file/phoneUpload"
        case .getUserPhoto:
            return baseURL + "/student/student/updateUserPhoto"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login, .updateUserPhoto, .updatePassowrd, .sendCode, .sureCode, .getUserPhoto, .updateUserPhoto:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    var parameters: [String : AnyObject]? {
        switch self {
        case .login(let username, let password):
            return ["username": username as AnyObject, "password": password as AnyObject]
        case .sendCode(let param):
            return param
        case .updatePassowrd(let param):
            return param
        case .sureCode(let param):
            return param
        case .updateUserPhoto(let name, let refRelationCategory):
            return ["name": name as AnyObject, "refRelationCategory": refRelationCategory as AnyObject]
        case .getUserPhoto(let photoUrl):
            return ["photoUrl":photoUrl as AnyObject]
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getUserPhoto:
            return ["token":"\(AppKeys.getUserToken())"]
        case .sureCode, .login:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        case .updatePassowrd, .sendCode, .updateUserPhoto:
            return ["Content-Type":"application/x-www-form-urlencoded", "token": "\(AppKeys.getUserToken())"]
        default:
            return nil
            
        }
    }

}
