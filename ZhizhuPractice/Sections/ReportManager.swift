//
//  ReportManager.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation


class ReportManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func getRowArray(section: Int) -> [String] {
        switch section {
        case 0:
            return ["实习任务"]
        case 1:
            return ["实习日志"]
        case 2:
            return ["实习周记"]
        case 3:
            return ["中期汇报"]
        case 4:
            return ["实习总结"]
        default:
            return []
            
        }
    }
    

    // 更新数据
    func updateData(dayModel: AllPracticeStatusModel, timeModel: AllExercitationTimesModel, topString: String) -> (content: String, image: String, rightText: String) {
        switch topString {
        case "签到":
            return ("已签到0天", "tab_select_0", "立即签到")
        case "实习任务":
            return ("剩余\(dayModel.missionLast!)天", "tab_select_1", "申报任务")
        case "实习日志":
            return ("已完成\(dayModel.dayCount!)/\(dayModel.plan.dailyNumber!)", "tab_select_2", "填写日志")
        case "实习周记":
            return ("已完成\(dayModel.weekCount!)/\(dayModel.plan.weekNumber!)", "tab_select_2", "填写周记")
        case "中期汇报":
            let begin = ZZHelper.timeFormat(timeStamp: timeModel.report.startTime, format: "yyyy/MM/dd")
            let end = ZZHelper.timeFormat(timeStamp: timeModel.report.endTime, format: "yyyy/MM/dd")
            return ("\(begin)-\(end)", "tab_select_2", getDetailDate(model: timeModel.report))
        case "实习总结":
            let begin = ZZHelper.timeFormat(timeStamp: timeModel.summary.startTime, format: "yyyy/MM/dd")
            let end = ZZHelper.timeFormat(timeStamp: timeModel.summary.endTime, format: "yyyy/MM/dd")
            return ("\(begin)-\(end)", "tab_select_2", getDetailDate(model: timeModel.summary))
        case "实习考核":
            let begin = ZZHelper.timeFormat(timeStamp: timeModel.assess.startTime, format: "yyyy/MM/dd")
            let end = ZZHelper.timeFormat(timeStamp: timeModel.assess.endTime, format: "yyyy/MM/dd")

            return ("\(begin)-\(end)", "tab_select_2", getDetailDate(model: timeModel.assess))
        default:
            return ("","","")
        }
    }
    
    func getDetailDate(model: SubTimesModel) -> String {
        switch model.status {
        // 未开始
        case 1:
            return "未开始"
        // 未完成
        case 2:
            return "未完成"
        // 已提交
        case 3:
            return "已提交"
        // 不确定的状态
        default:
            return "不确定状态"
            
        }

    }
    
    // 新增日志/周记
    func getLogAddRow(type: ControllerType, row: Int) ->(topString: String, placeHolder: String) {
        switch row {
        case 0:
            switch type {
            case .Log:
                return ("项目进展情况","请填写项目进展情况, 不少于100字!")
            case .WeekReport:
                return ("本周实践工作简述","请填写本周实践工作简述, 不少于100字!")
            }
            
        case 1:
            switch type {
            case .Log:
                return ("本人参与工程实践情况","请填写本人参与工程实践情况, 不少于100字!")
            case .WeekReport:
                return ("本周所学知识要点","请填写本周所学知识要点, 不少于100字!")
            }
            
        default:
            switch type {
            case .Log:
                return ("设计规范标准","请填写设计规范标准, 不少于100字!")
            case .WeekReport:
                return ("","")
            }
        }
    }
}
