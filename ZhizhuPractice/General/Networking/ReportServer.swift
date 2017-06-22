//
//  ReportServer.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/27.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
import Alamofire


enum ReportServer {
    // 查询学生的实习任务(任务实施/任务申报）status:1(查询任务实施,已经审核通过的记录) 查询任务申报 不需要  plantId 实习计划Id
    case getMissionDeclareList(param: [String: AnyObject])
    // 查询学生任务申报详情 missionDeclareId任务申报Id
    case getMissionDeclareDetails(missionDeclareId: String)
    // 查询学生任务审核记录 missionDeclareId任务申报Id
    case getAuditRecordList(missionDeclareId: String)
    // 查询学生任务实施情况(或者任务实施教师点评) refTable:'MISSION_IMPLEMENT_COLLECTION'(收集资料、对照学习) MISSION_IMPLEMENT_STUDY( 跟踪模仿、学习理解) 'MISSION_IMPLEMENT_IMPL'(任务实施)
    case getMissionImplement(param: [String: AnyObject])
    // 查询中期汇报/实习总结 type类型（1.中期汇报 2.实习总结)
    case getSummaryByPlanIdAndType(type: Int, planId: String)
    // 查询考核成绩
    case getExamingScores(planId: String)
    // 查询岗前准备时间和实习进行时间 type PRE_TIME(查询岗前准备阶段时间) CONDUCT_TIME(查询实习进行阶段时间
    case getProcedureTimeByParam(type: String, planId: String)
    // 查询学生总体实习情况(包括日周记个数)
    case getExercitationGoingInfos
    //查询学生不同阶段实习情况(包括中期汇报/实习总结时间段)
    case getExercitationGoingTimes
    // 查询用户详细信息
    case getCurUserDetail
    // 查询当前的实习计划Id
    case getExercitationByUserId(userId: String)
    // 查询学生参与的所有实习计划
    case getPlanListByUserId
    // 查询实习计划时间
    case getStageTime
    // 查询学生最新动态 size 列表信息显示个数
    case getUserLogsList(size: Int)
    // 查询实习日、周记 type:1.实习日记 2.实习周记  offset: 0 ?
    case getStudentDailyReports(pageSize: Int, planId: String, type: Int, offset: Int)
    // 查询实习日、周记详情 日周记id
    case getStudentDailyReportDetail(id: String)
    // 保存实习日、周记详情
    // id:日周记id  exercitationPlanId:实习计划ID type:1.日志 2.周记 description:项目进展情况 practice:本人参与工程实践 standards:设计规范标准 files:上传的文件(file类型)
    case saveDailyReportDetail(param: [String: AnyObject])
    // 进行实习计划登记
    case companyRegister(param: [String: AnyObject])
    // 查询实习计划登记详情
    case getCompanyRegister(planId: String)
    // 上传问卷答案
    case answerSubject(param: [String: AnyObject])
    
}


extension ReportServer:TargetType {
    var method: HTTPMethod {
        switch self {
        case .getMissionDeclareList, .getExercitationByUserId, .getMissionDeclareDetails, .getAuditRecordList, .getMissionImplement, .getSummaryByPlanIdAndType, .getExamingScores, .getProcedureTimeByParam, .getExercitationGoingInfos, .getExercitationGoingTimes, .getCurUserDetail, .getPlanListByUserId, .getStageTime, .getUserLogsList, .getCompanyRegister, .getStudentDailyReports, .getStudentDailyReportDetail:
            return .get
        default:
            return .post
        }
    }
    
    var path: URLConvertible {
        switch self {
        case .getMissionDeclareList:
            return baseURL + "/student/missionDeclare/getMissionDeclareList"
        case .getExercitationByUserId:
            return baseURL + "/student/ExercitationPrepare/getExercitationByUserId"
        case .getMissionDeclareDetails:
            return baseURL + "/student/missionDeclare/getMissionDeclareDetails"
        case .getAuditRecordList:
            return baseURL + "/student/missionDeclare/getAuditRecordList"
        case .getMissionImplement:
            return baseURL + "/student/missionDeclare/getMissionImplement"
        case .getSummaryByPlanIdAndType:
            return baseURL + "/student/summary/getSummaryByPlanIdAndType"
        case .getExamingScores:
            return baseURL + "/exercitation/examing/getExamingScores"
        case .getProcedureTimeByParam:
            return baseURL + "/student/missionDeclare/getProcedureTimeByParam"
        case .getExercitationGoingInfos:
            return baseURL + "/exercitation/going/getExercitationGoingInfos"
        case .getExercitationGoingTimes:
            return baseURL + "/exercitation/going/getExercitationGoingTimes"
        case .getCurUserDetail:
            return baseURL + "/student/student/getCurUserDetail"
        case .getPlanListByUserId:
            return baseURL + "/student/student/getPlanListByUserId"
        case .getStageTime:
            return baseURL + "/student/ExercitationPrepare/getStageTime"
        case .getUserLogsList:
            return baseURL + "/student/student/getUserLogsList"
        case .getStudentDailyReports:
            return baseURL + "/exercitation/going/getStudentDailyReports"
        case .getStudentDailyReportDetail:
            return baseURL + "/exercitation/going/getStudentDailyReportDetail"
        case .saveDailyReportDetail:
            return baseURL + "/student/dailyReport/saveOrUpdate"
        case .getCompanyRegister:
            return baseURL + "/student/ExercitationPrepare/getCompanyRegister"
        case .companyRegister:
            return baseURL + "/student/ExercitationPrepare/companyRegister"
        case .answerSubject:
            return baseURL + "/student/ExercitationPrepare/answerSubject"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getMissionDeclareList, .getExercitationByUserId, .getMissionDeclareDetails, .getAuditRecordList, .getMissionImplement, .getSummaryByPlanIdAndType, .getExamingScores, .getProcedureTimeByParam, .getExercitationGoingInfos, .getExercitationGoingTimes, .getCurUserDetail, .getPlanListByUserId, .getStageTime, .getUserLogsList, .getCompanyRegister, .getStudentDailyReports, .getStudentDailyReportDetail, .answerSubject, .companyRegister, .saveDailyReportDetail:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .getMissionDeclareList(let param):
            return param
        case .getExercitationByUserId(let userId):
            return ["userId": userId as AnyObject]
        case .getMissionDeclareDetails(let missionDeclareId):
            return ["missionDeclareId": missionDeclareId as AnyObject]
        case .getAuditRecordList(let missionDeclareId):
            return ["missionDeclareId": missionDeclareId as AnyObject]
        case .getMissionImplement(let param):
            return param
        case .getSummaryByPlanIdAndType(let type, let planId):
            return ["type": type as AnyObject, "planId": planId as AnyObject]
        case .getExamingScores(let planId):
            return ["planId": planId as AnyObject]
        case .getProcedureTimeByParam(let type, let planId):
            return ["type": type as AnyObject, "planId": planId as AnyObject]
        case .getUserLogsList(let size):
            return ["size": size as AnyObject]
        case .getStudentDailyReports(let pageSize, let planId, let type, let offset):
            return ["pageSize": pageSize as AnyObject, "planId": planId as AnyObject, "type": type as AnyObject, "offset": offset as AnyObject]
        case .getStudentDailyReportDetail(let id):
            return ["id": id as AnyObject]
        case .saveDailyReportDetail(let param):
            return param
        case .getCompanyRegister(let planId):
            return ["planId": planId as AnyObject]
        case .companyRegister(let param):
            return param
        case .answerSubject(let param):
            return param
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getExercitationGoingInfos, .getExercitationGoingTimes, .getCurUserDetail, .getPlanListByUserId, .getStageTime, .getUserLogsList, .getStudentDailyReports, .getStudentDailyReportDetail, .getMissionDeclareList, .getExercitationByUserId, .getMissionDeclareDetails, .getAuditRecordList, .getMissionImplement, .getSummaryByPlanIdAndType, .getExamingScores, .getProcedureTimeByParam, .getCompanyRegister:
            
            return ["token": "\(AppKeys.getUserToken())"]
        case  .saveDailyReportDetail,.answerSubject, .companyRegister:
           return ["Content-Type":"application/x-www-form-urlencoded", "token": "\(AppKeys.getUserToken())"]

            
        }
    }
    
}
