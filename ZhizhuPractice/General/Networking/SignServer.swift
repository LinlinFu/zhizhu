//
//  SignServer.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/27.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
import Alamofire


enum SignServer {
    // 获取学生一个月签到情况 date: 年月(低于10 的前加0) planId:计划Id
    // 例如: date=201706&planId=148099410377169360
    case getStudentMonthSignList(date: String, planId: String)
    // 签到记录保存 exercitationPlanId当前实习计划ID attendanceAddress城市信息 attendanceLatitude 坐标值
    case saveSignRecord(param: [String: AnyObject])
    // 查询学生当天是否已经签到
    case getStudentAttendanceCount
    // 获取签到和未签到个数  yearDay:年+“—”+月 例:2017-05 planId:实习计划ID
    case getAttendanceCount(yearDay: String, planId: String)
    
}


extension SignServer:TargetType {
    var method: HTTPMethod {
        switch self {
        case .getStudentMonthSignList, .getStudentAttendanceCount, .getAttendanceCount:
            return .get
        case .saveSignRecord:
            return .post
        }
    }
    
    var path: URLConvertible {
        switch self {
        case .getStudentMonthSignList:
            return baseURL + "/exercitation/going/getStudentMonthSignList"
        case .saveSignRecord:
            return baseURL + "/student/attendance/save"
        case .getStudentAttendanceCount:
            return baseURL + "/student/attendance/getStudentAttendanceCount"
        case .getAttendanceCount:
            return baseURL + "/student/attendance/getAttendanceCount"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getStudentMonthSignList, .getStudentAttendanceCount, .getAttendanceCount, .saveSignRecord:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getStudentMonthSignList(let date, let planId):
            return ["date": date as AnyObject, "planId": planId as AnyObject]
        case .saveSignRecord(let param):
            return param
        case .getAttendanceCount(let yearDay, let planId):
            return ["yearDay": yearDay as AnyObject, "planId": planId as AnyObject]
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getStudentAttendanceCount, .getAttendanceCount, .getStudentMonthSignList:
            return ["token": "\(AppKeys.getUserToken())"]
        case .saveSignRecord:
        return  ["Content-Type":"application/x-www-form-urlencoded", "token": "\(AppKeys.getUserToken())"]
            
        }
    }
    
}
