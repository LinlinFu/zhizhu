//
//  PrepareManager.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
class PrepareManager: NSObject {
    
    override init() {
        super.init()
    }
    
    // "实习报道"
    func getReportRowArray(section: Int) -> [String] {
        switch section {
        case 0:
            return ["到岗时间", "作息时间", "工作内容", "公司规定", "疑难救助"]
        case 1:
            return ["审核结果", "审核时间"]
        default:
            return []
        }
    }
    
    // "工地情况反馈"
    func getFeekbackRowArray(section: Int) -> [String] {
        switch section {
        case 0:
            return ["师傅姓名", "性别", "职务", "毕业院校", "学历", "手机号码", "主要业绩"]
        case 1:
            return ["工程名称", "建筑面积", "层数", "结构形式", "装修"]
        case 2:
            return ["建设", "监理", "设计", "勘察"]
        case 3:
            return ["目前工程施工形象部位", "实习结束预计形象部位", "住宿地址", "住宿情况"]
        case 4:
            return ["占位"]
        case 5:
            return ["审核结果", "审核时间", "评语"]
        default:
            return []
            
        }
    }
    // "工地情况反馈"
    func getFeekbackTitleOfSection(section: Int) ->String {
        switch section {
        case 0:
            return "一、实习师傅信息"
        case 1:
            return "二、工地基本信息"
        case 2:
            return "三、参见单位情况"
        case 3:
            return "四、工地其他信息"
        case 4:
            return "五、对实习工地及实习任务的认识与描述"
        case 5:
            return "审核记录"
        default:
            return ""
        }
    }
    
    // 工地情况反馈
    func returnRightText(topString: String, model: FeekbackModel) -> String {
        
        switch topString {
        case "师傅姓名":
            return model.teacherName
        case "性别":
            return model.sex == 1 ? "男" : "女"
        case "职务":
            return model.duties
        case "毕业院校":
            return model.schoolName
        case "学历":
            return model.education
        case "手机号码":
            return model.mobile
        case "主要业绩":
            return model.achievements
        case "工程名称":
            return model.projectName
        case "建筑面积":
            return model.buildingArea
        case "层数":
            return model.levelNumber
        case "结构形式":
            return model.structuralStyle
        case "装修":
            return model.fitment
        case "建设":
            return model.development
        case "监理":
            return model.supervisionCompany
        case "设计":
            return model.design
        case "勘察":
            return model.survey
        case "目前工程施工形象部位":
            return model.projectCurrentStatus
        case "实习结束预计形象部位":
            return model.projectEndStatus
        case "住宿地址":
            return model.worksiteAddress
        case "住宿情况":
            return model.houseAddress
        default:
            return ""
        }
    }
    
    
    // 新版工地情况反馈
    func returnDetailData(topString: String, model: FeekbackModel) -> (rightText:String, rightFiledHidden:Bool, rightLabelHidden:Bool) {
        
        switch topString {
        case "师傅姓名":
            return (model.teacherName, false, true)
        case "性别":
            return (model.sex == 1 ? "男" : "女", true, false)
        case "职务":
            return (model.duties, false, true)
        case "毕业院校":
            return (model.schoolName, false, true)
        case "学历":
            return (model.education, true, false)
        case "手机号码":
            return (model.mobile, false, true)
        case "主要业绩":
            return (model.achievements, false, true)
        case "工程名称":
            return (model.projectName, false, true)
        case "建筑面积":
            return (model.buildingArea, false, true)
        case "层数":
            return (model.levelNumber, false, true)
        case "结构形式":
            return (model.structuralStyle, false, true)
        case "装修":
            return (model.fitment, false, true)
        case "建设":
            return (model.development, false, true)
        case "监理":
            return (model.supervisionCompany, false, true)
        case "设计":
            return (model.design, false, true)
        case "勘察":
            return (model.survey, false, true)
        case "目前工程施工形象部位":
            return (model.projectCurrentStatus, false, true)
        case "实习结束预计形象部位":
            return (model.projectEndStatus, false, true)
        case "住宿地址":
            return (model.worksiteAddress, false, true)
        case "住宿情况":
            return (model.houseAddress, false, true)
        default:
            return ("", false, true)
        }
    }

    
    // 实习计划
    func getPlanRowArray(section: Int) -> [String] {
        switch section {
        case 0:
            return ["实习动员", "安全教育", "实习承诺", "实习计划登记", "工地情况反馈", "上传附件"]
        case 1:
            return ["实习签到", "实习日志", "实习周记", "实习任务", "中期汇报", "实习总结"]
        case 2:
            return ["查看成绩"]
        default:
            return []
            
        }
    }
    
    // 考核成绩
    func getGradesRowArray(section: Int) -> [String] {
        switch section {
        case 0:
            return ["签到得分", "日志得分", "周记得分", "任务得分", "中期得分", "总结得分"]
        default:
            return []
            
        }
    }
    
    
    
    
}
