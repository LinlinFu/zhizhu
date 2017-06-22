//
//  ZZPickerView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/20.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

@objc protocol ZZPickerViewDelegate {
    func clickedCancle()
    @objc optional func clickedSure(selectedAddress: String)
    @objc optional func dateDidSelecte(date: Date)
}


// 选择器类型
enum PickerType: String {
    case Time = "Time"
    case Address = "Address"
}

class ZZPickerView: UIView {

    var type: PickerType = .Time
    var topView: UIView!
    var cancle: UIButton!
    var sure: UIButton!
    // 设置topView高度
    var heightTop: CGFloat = 40 {
        willSet {
            layoutSubview(heightTop: newValue)
        }
    }
    
    
    var delegate: ZZPickerViewDelegate!

    //日期选择器
    var pickerView: UIPickerView!
    //时间选择器
    var datePicker: UIDatePicker!

    //省 数组
    var provincesData:NSArray!
    //市 数组
    var citiesData:NSArray!
    //区 数组
    var districtsData:NSArray!
    
    //省 字典
    var provincesList:NSDictionary!
    //市 字典
    var citiesList:NSDictionary!
    
    //选择的省
    var selectedProvince:String!
    //选择的市
    var selectedCity:String!
    //选择的区
    var selectedDistrict:String!
    
    // 选择的总地址
    var selectedAddress = ""
    // 选择的时间
    var selectedDate = Date()
    
    
    init(pickerType: PickerType = .Time, frame: CGRect) {
        super.init(frame: frame)
        type = pickerType
        setupUI()

        
    }

    
    func setupUI () {
        topView = UIView()
        cancle = UIButton()
        sure = UIButton()
        addSubview(topView)
        switch type {
        case .Address:
            pickerView = UIPickerView()
            addSubview(pickerView)
        case .Time:
            datePicker = UIDatePicker()
            addSubview(datePicker)
        }
        
        [cancle, sure].forEach { (btn) in
            topView.addSubview(btn)
        }
        layoutSubview(heightTop: heightTop)
        
        topView.backgroundColor = ZZLightGrayBg_F7F7F7
        cancle.setTitle("取消", for: .normal)
        cancle.setTitleColor(ZZMainGreen, for: .normal)
        cancle.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(ZZMainGreen, for: .normal)
        sure.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        setupPickerView()

    }
    
    func setupPickerView() {
        switch type {
        case .Address:
            
            //将dataSource设置成自己
            pickerView.dataSource = self
            //将delegate设置成自己
            pickerView.delegate = self
            //得到本地文件路径
            let addressPath = Bundle.main.path(forResource: "address", ofType: "plist")
            //得到字典类型数据
            let dicPList = NSDictionary(contentsOfFile: addressPath!)!
            self.provincesList = dicPList
            self.provincesData = self.provincesList.allKeys as NSArray!
            
            //初始化
            //默认取出第一个省、市、区的数据
            self.selectedProvince = self.provincesData[0] as! String
            self.citiesList = self.provincesList[selectedProvince] as! NSDictionary
            self.citiesData = self.citiesList.allKeys as NSArray!
            self.selectedCity = self.citiesData[0] as! String
            self.districtsData = self.citiesList[selectedCity] as! NSArray
            self.selectedDistrict = self.districtsData[0] as! String
            
            
        case .Time:
  
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = Locale(identifier: "zh_CN")
             datePicker.datePickerMode = .date
             datePicker.date = Date()
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(dateChanged),
                                 for: .valueChanged)
            
        }

    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        selectedDate = datePicker.date
    }
    
    //取消
    func cancleAction() {
        delegate.clickedCancle()
    }
    
    
    //确定
    func sureAction() {
        switch type {
        case .Address:
            selectedAddress = "\(selectedProvince!)-" + "\(selectedCity!)-" + "\(selectedDistrict!)"
            delegate.clickedSure!(selectedAddress: selectedAddress)
        case .Time:
            delegate.dateDidSelecte!(date: selectedDate)
            
        }
    }
    
    func layoutSubview(heightTop: CGFloat) {
        topView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(heightTop)
            make.top.equalTo(0)
        }
        
        switch type {
        case .Address:
            pickerView.snp.makeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom)
                make.left.right.bottom.equalTo(0)
            }
        case .Time:
            datePicker.snp.makeConstraints { (make) in
                make.top.equalTo(topView.snp.bottom)
                make.left.right.bottom.equalTo(0)
            }
        }
        
        cancle.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(heightTop)
            make.width.equalTo(70)
        }
        
        sure.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(topView.snp.centerY)
            make.height.equalTo(heightTop)
            make.width.equalTo(70)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZPickerView: UIPickerViewDelegate,UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .Address:
            if component  == 0 {
                return self.provincesData.count
            }else if component == 1 {
                return self.citiesData.count
            }else{
                return self.districtsData.count
            }
            
        default:
            return 0
        }
    }

    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        switch type {
        case .Address:
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            if component  == 0 {
                 label.text = self.provincesData[row] as? String
            }else if component == 1 {
                label.text = self.citiesData[row] as? String
            }else{
                label.text = self.districtsData[row] as? String
            }
            return label
        default:
            return UIView()
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .Address:
            if component  == 0 {
                self.selectedProvince = self.provincesData[row] as! String
                self.citiesList = self.provincesList[selectedProvince] as! NSDictionary
                self.citiesData = citiesList.allKeys as NSArray
                self.selectedCity = self.citiesData[0] as! String
                self.districtsData = self.citiesList[selectedCity] as! NSArray
                self.selectedDistrict = self.districtsData[0] as! String
                self.pickerView.reloadComponent(1)
                self.pickerView.reloadComponent(2)
//                NSLog("选择的省"+selectedProvince)
            }else if component == 1 {
                self.selectedCity = self.citiesData[row] as! String
                self.districtsData = self.citiesList[selectedCity] as! NSArray
                self.selectedDistrict = self.districtsData[0] as! String
                self.pickerView.reloadComponent(2)
                
//                NSLog("选择的市"+selectedCity)
            }else{
                self.selectedDistrict = self.districtsData[row] as! String
//                NSLog("选择的区"+selectedDistrict)
            }
            
        default:
            return
        }
    }
}
