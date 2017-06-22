//
//  SignViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class SignViewController: BaseViewController {

    
    var calendarView: FSCalendar!
    var leftBtn: UIButton!
    var rightBtn: UIButton!
    var monthNumber = ""
    var selectedDate: String = ""
    // 已签到
    var alreadySignImage: UIImageView!
    var alreadySignLabel: UILabel!
    // 未签到
    var noSignImage: UIImageView!
    var noSignLabel: UILabel!
    
    //当前月份??????????
    var currentYearMonth = ""
    var yearNumber = ""
    
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    
    var attendanceArray: [AttendanceModel] = []
    var attendanceDateArray = [""]
    var startTime = ""
    var endTime = ""
    
    var todayDate = Date()
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    let fillDefaultColors = ["2017/05/08": UIColor.purple, "2017/05/06": UIColor.green]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupUI()
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 20))
        but.setTitle("签到", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
        
        
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month], from: self.calendarView.currentPage)
        monthNumber = String(com.month!)
        yearNumber = String(com.year!)
        if monthNumber.characters.count < 2 {
            monthNumber = "0\(monthNumber)"
            
        }
        // 获取出勤和未出勤天数
        getAttendanceCount()
        // 获取一个月签到具体情况
        getDetailAttendanceStatus()


        
    }
    
    func signAction() {
        let vc = SignDetailViewController()
        vc.planId = planId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        alreadySignImage = UIImageView()
        noSignImage = UIImageView()
        alreadySignLabel = UILabel()
        noSignLabel = UILabel()
        
        [alreadySignImage, alreadySignLabel, noSignImage, noSignLabel].forEach { (sub) in
            view.addSubview(sub)
        }
        [alreadySignImage, noSignImage].forEach { (img) in
            img?.layer.cornerRadius = 10
            img?.layer.masksToBounds = true
        }
        alreadySignImage.backgroundColor = ZZMainGreen
        noSignImage.backgroundColor = ZZRed
        [alreadySignLabel, noSignLabel].forEach { (label) in
            label?.font = UIFont.systemFont(ofSize: 14)
        }
        layoutSubview()
        
        
    }
    
    func layoutSubview() {
        alreadySignImage.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(20)
            make.top.equalTo(calendarView.snp.bottom).offset(10)
        }
        alreadySignLabel.snp.makeConstraints { (make) in
            make.top.equalTo(alreadySignImage.snp.top)
            make.bottom.equalTo(alreadySignImage.snp.bottom)
            make.left.equalTo(alreadySignImage.snp.right).offset(10)
        }
        noSignImage.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(20)
            make.top.equalTo(alreadySignImage.snp.bottom).offset(10)
        }
        noSignLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noSignImage.snp.top)
            make.bottom.equalTo(noSignImage.snp.bottom)
            make.left.equalTo(noSignImage.snp.right).offset(10)
        }
    }
    
    func setupView() {
        
        calendarView = FSCalendar.init(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 290))
        setupCalendar()
        view.addSubview(calendarView)
        
        
//        leftBtn = UIButton(frame:CGRect(x: 25, y: 20, width: 16, height: 16))
//        leftBtn.setImage(UIImage(named: "bill_lastMonth"), for: .normal)
//        leftBtn.addTarget(self, action: #selector(lastMonthAction), for: .touchUpInside)
//        calendarView.addSubview(leftBtn)
        
//        rightBtn = UIButton(frame: CGRect(x: ZZScreenWidth - 25 - 16, y: 20, width: 16, height: 16))
//        rightBtn.setImage(UIImage(named: "bill_nextMonth"), for: .normal)
//        rightBtn.addTarget(self, action: #selector(nextMonthAction), for: .touchUpInside)
//        calendarView.addSubview(rightBtn)
        
        
        
    }

    func setupCalendar() {
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.firstWeekday = 2
        calendarView.appearance.adjustsFontSizeToFitContentSize = false
        // headerView
        calendarView.appearance.headerTitleColor = ZZRed
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16)
        calendarView.headerHeight = 60
        calendarView.appearance.headerDateFormat = "yyyy年MM月"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        // 关于周
        // 星期几是中文
        calendarView.locale = NSLocale.init(localeIdentifier: "zh-CN") as Locale
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 13)
        calendarView.appearance.weekdayTextColor = ZZGray
        calendarView.appearance.caseOptions = .weekdayUsesSingleUpperCase
        // 关于今日
        calendarView.appearance.todayColor = UIColor.white
        calendarView.appearance.titleTodayColor = ZZWhiteBackground
        // 关于选中
        calendarView.appearance.selectionColor = ZZRed
        // 关于默认日期
        calendarView.appearance.titleDefaultColor = ZZWhiteBackground
        // 不显示上月下月的占位日期
        calendarView.placeholderType = .none
        
        // mainCalendarView.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendarView.clipsToBounds = true
        
//        currentYearMonth = calendarView.currentPage
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    //MARK: 查询已签到为未签到个数
    func getAttendanceCount() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<SignServer>().requestReturnDictionary(target: .getAttendanceCount(yearDay: "\(yearNumber)-\(monthNumber)", planId: planId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && (JSON(info)["status"].stringValue == "200") {
                self.alreadySignLabel.text = "已签\(JSON(info)["resultObject"]["alreadycount"].stringValue)"
                self.noSignLabel.text = "未签\(JSON(info)["resultObject"]["nocount"].stringValue)"
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: 查询一个月具体签到情况
    func getDetailAttendanceStatus() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        
        ServerProvider<SignServer>().requestReturnDictionary(target: .getStudentMonthSignList(date: yearNumber + monthNumber, planId:planId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && (JSON(info)["status"].stringValue == "200") {
                self.attendanceDateArray.removeAll()
                self.startTime = JSON(info)["resultObject"]["startTime"].stringValue
                print(self.startTime)
                self.endTime =  JSON(info)["resultObject"]["endTime"].stringValue
                for data in JSON(info)["resultObject"]["attendance"].arrayValue {
                    let model = AttendanceModel(json: data)
                    self.attendanceArray.append(model)
                    let date = ZZHelper.timeFormat(timeStamp: model.attendanceTime, format: "yyyy/MM/dd")
                    self.attendanceDateArray.append(date)
                    
                }
                self.calendarView.reloadData()
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

   

}

extension SignViewController {
//    // 上个月
//    func lastMonthAction() {
//        monthNumber -= 1
//        let currentDate = Date()
//        var newDateComponent = DateComponents()
//        newDateComponent.month = monthNumber
//        let calculatedDate = Calendar.current.date(byAdding: newDateComponent, to: currentDate)
//        calendarView.setCurrentPage(calculatedDate!, animated: true)
//        getDetailAttendanceStatus()
//    }
//    
//    // 下个月
//    func nextMonthAction() {
//        monthNumber += 1
//        let currentDate = Date()
//        var newDateComponent = DateComponents()
//        newDateComponent.month = monthNumber
//        let calculatedDate = Calendar.current.date(byAdding: newDateComponent, to: currentDate)
//        calendarView.setCurrentPage(calculatedDate!, animated: true)
//        getDetailAttendanceStatus()
//        
//    }
    
    // 查看筛选结果
    func filterAction() {
        print("结果")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: selectedDate)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
extension SignViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = NSTimeZone.local
        let dateFormat = df.string(from: date)
        selectedDate = dateFormat  
        print(selectedDate)
        
        if selectedDate == "\(df.string(from: Date()))" {
            print("今天啊")
        } else {
            print("都不能点")
            calendar.deselect(date)
        }

        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    
    //MARK: 滑动切换月份时候
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        // 当前时间
        let date = calendar.currentPage
        let zone = NSTimeZone.local
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
//        print(localeDate)
        // 当前年月
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month], from: localeDate)
        monthNumber = String(com.month!)
        if monthNumber.characters.count < 2 {
            monthNumber = "0\(monthNumber)"
            
        }
        yearNumber = String(com.year!)
//        print("!!!!!!!!!!!!!yearNumber\(yearNumber), monthNumber\(monthNumber)")
        // 获取出勤和未出勤天数
        getAttendanceCount()
        // 获取一个月签到具体情况
        getDetailAttendanceStatus()

     

    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        
        print(todayDate)
       let todayStamp =
        (ZZHelper.stringToTimeStamp(stringTime: self.dateFormatter1.string(from: todayDate), format: "yyyy/MM/dd") as NSString).doubleValue
        let anyStamp = (ZZHelper.stringToTimeStamp(stringTime: self.dateFormatter1.string(from: date), format: "yyyy/MM/dd") as NSString).doubleValue
        let startStamp = (self.startTime as NSString).doubleValue / 1000.0
//        print("todayStamp \(todayStamp),anyStamp \(anyStamp), startStamp \(startStamp)")
        if anyStamp < startStamp {
            return ZZLightGrayBg
        } else {
            if anyStamp <= todayStamp {
                let final = self.dateFormatter1.string(from: date)
                if attendanceDateArray.contains(final) {
                    return ZZMainGreen
                } else {
                    return ZZRed
                }
            }
            return ZZLightGrayBg
        }
        
    }
    
    
    
}

