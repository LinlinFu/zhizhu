//
//  PrepareServer.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation

import Alamofire


enum PrepareServer {
    // 获取是否存在实习计划
    case getCurrentStage
    // 进入下一阶段 stage:'STAGE11_MOBILIZATION'
    case gotoNextStage(stage: String)
    // 查询视频路径
    case serchVideoPath(type: String)
    // 获取用户通知 pageSize offset:0? fileHostDomain:“http://172.16.1.253:8080”?
    case getCurUserMsgs(pageSize: Int, offset: Int)
    // 查询未读消息数量
    case getUserNoReadMsgCount
    // 删除用户通知 通知ID
    case delMsgReceive(id: String)
    // 获取安全教育的视频地址? type'SAFETY_EDUCATION_VIDEO'
    case getSafeEducation(planId: String)
    //查询工地反馈详情
    case getWorksiteFeedback(planId: String)
    // 查询实习报道详情
    case getCompanyReport(planId: String)
    // 获取版本号
    case getAppVersion
    // 获取通知详情
    case getMsgDetail(id: String, receiveId: String)
    // 获取实习计划时间
    case getStageTime
    // 获得考试题
    case getCurrentExamSubject(pageSize: Int, offset:Int)
    
}


extension PrepareServer:TargetType {
    var method: HTTPMethod {
        switch self {
        case .getCurrentStage, .getCurUserMsgs, .serchVideoPath, .getUserNoReadMsgCount, .getSafeEducation, .getWorksiteFeedback, .getAppVersion, .getCompanyReport, .getMsgDetail, .getStageTime, .getCurrentExamSubject:
            return .get
        case .gotoNextStage, .delMsgReceive:
            return .post

        }
    }
    
    var path: URLConvertible {
        switch self {
        case .getCurrentStage:
            return baseURL + "/student/ExercitationPrepare/getCurrentStage"
        case .getCurUserMsgs:
            return baseURL + "/msg/msg/getCurUserMsgs"
        case .serchVideoPath:
            return baseURL + "/student/ExercitationPrepare/getVideoByType"
        case .getUserNoReadMsgCount:
            return baseURL + "/msg/msg/getUserNoReadMsgCount"
        case .delMsgReceive:
            return baseURL + "/msg/msg/delMsgReceive"
        case .gotoNextStage:
            return baseURL + "/student/ExercitationPrepare/gotoNextStage"
        case .getSafeEducation:
            return baseURL + "/student/ExercitationPrepare/getSafeEducation"
        case .getWorksiteFeedback:
            return baseURL + "/student/ExercitationPrepare/getWorksiteFeedback"
        case .getAppVersion:
            return baseURL + "/msg/msg/getAppVersion"
        case .getCompanyReport:
            return baseURL + "/student/ExercitationPrepare/getCompanyReport"
        case .getMsgDetail:
            return baseURL + "/msg/msg/getMsgDetail"
        case .getStageTime:
            return baseURL + "/student/ExercitationPrepare/getStageTime"
        case .getCurrentExamSubject:
            return baseURL + "/student/ExercitationPrepare/getCurrentExamSubject"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getCurrentStage, .getCurUserMsgs, .serchVideoPath, .getUserNoReadMsgCount, .delMsgReceive, .getSafeEducation, .getWorksiteFeedback, .gotoNextStage, .getAppVersion, .getCompanyReport, .getMsgDetail, .getStageTime, .getCurrentExamSubject:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getCurUserMsgs(let pageSize, let offset):
            return ["pageSize": pageSize as AnyObject, "offset": offset as AnyObject, "fileHostDomain": baseURL as AnyObject]
        case .serchVideoPath(let type):
            return ["type": type as AnyObject]
        case .delMsgReceive(let id):
            return ["id": id as AnyObject]
        case .gotoNextStage(let stage):
            return ["stage": stage as AnyObject]
        case .getSafeEducation(let planId):
            return ["planId": planId as AnyObject]
        case .getWorksiteFeedback(let planId):
            return ["planId": planId as AnyObject]
        case .getCompanyReport(let planId):
            return ["planId": planId as AnyObject]
        case .getMsgDetail(let id, let receiveId):
            return ["receiveId": receiveId as AnyObject, "id": id as AnyObject]
        case .getCurrentExamSubject(let pageSize, let offset):
            return ["pageSize": pageSize as AnyObject, "offset": offset as AnyObject]
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .gotoNextStage:
            return ["Content-Type":"application/x-www-form-urlencoded", "token": "\(AppKeys.getUserToken())"]
        case .getCurrentStage, .serchVideoPath, .getUserNoReadMsgCount, .getCurUserMsgs, .getWorksiteFeedback, .delMsgReceive, .getSafeEducation, .getAppVersion, .getCompanyReport, .getMsgDetail, .getStageTime, .getCurrentExamSubject:
            let token = AppKeys.getUserToken()
            return ["token": "\(token)"]

            
        }
    }
    
}
