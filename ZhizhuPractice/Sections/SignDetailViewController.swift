//
//  SignDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class SignDetailViewController: BaseViewController {

    // 地图
    var mapView: MAMapView!
    //
    var sureButton: UIButton!
    // 
    var locationView: UIView!
    var locationLabel: UILabel!
    var addressLabel: UILabel!
    var planId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAttendanceStatus()
        buildMapView()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.setZoomLevel(16.1, animated: true)
        self.mapView.setCenter(CLLocationCoordinate2DMake(ZZUserLocation.latitude, ZZUserLocation.longitude), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        [sureButton, locationView, locationLabel, addressLabel].forEach { (keyview) in
            keyview?.removeFromSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "签到"
    }
    
    
    //MARK: 查询学生当天是否已经签到
    func getAttendanceStatus() {
        
        ServerProvider<SignServer>().requestReturnDictionary(target: .getStudentAttendanceCount) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && (JSON(info)["status"].stringValue == "200") {
                let resultObject = JSON(info)["resultObject"].intValue
                if resultObject == 1 {
                    self.sureButton.backgroundColor = ZZLightGrayBg
                    self.sureButton.setTitle("已签到", for: .normal)
                    self.sureButton.isEnabled = false
                } else if resultObject == 0 {
                    self.sureButton.backgroundColor = ZZMainGreen
                    self.sureButton.setTitle("确认签到", for: .normal)
                    self.sureButton.isEnabled = true
                }
            } else {
                let errorMessage = JSON(info)["errorMessage"].stringValue
                let vc = RemindViewController(title: errorMessage, type: .failure)
                self.present(vc, animated: true, completion: nil)

                
            }
        }
    }

    //MARK: 签到记录保存
    func saveAttendanceRecord() {
        let param: [String: AnyObject] = ["exercitationPlanId":planId as AnyObject,"attendanceAddress": ZZUserAddress as AnyObject,"attendanceLatitude":"\(ZZUserLocation.latitude),\(ZZUserLocation.longitude)" as AnyObject]
        ServerProvider<SignServer>().requestReturnDictionary(target: .saveSignRecord(param: param)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && (JSON(info)["status"].stringValue == "200") {
                let vc = RemindViewController(title: "签到成功", type: .success)
                self.present(vc, animated: true, completion: nil)
                self.sureButton.backgroundColor = ZZLightGrayBg
                self.sureButton.setTitle("已签到", for: .normal)
                self.sureButton.isEnabled = false
            } else {
                let errorMessage = JSON(info)["errorMessage"].stringValue
                if errorMessage == "今天你已经签到，请不要重复签到！" {
                    self.sureButton.backgroundColor = ZZLightGrayBg
                    self.sureButton.setTitle("已签到", for: .normal)
                    self.sureButton.isEnabled = false
                } else {
                    let vc = RemindViewController(title: errorMessage, type: .failure)
                    self.present(vc, animated: true, completion: nil)

                }
                
                
            }
        }
    }

    // AMRK:签到历史
    func historySignAction() {
        print("签到历史")
    }
    func buildMapView() {
        AMapServices.shared().enableHTTPS = true
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
        
    }
    
    func setupUI() {
        sureButton = UIButton()
        UIApplication.shared.keyWindow?.addSubview(sureButton)
        sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        locationView = UIView()
        locationLabel = UILabel()
        addressLabel = UILabel()
        UIApplication.shared.keyWindow?.addSubview(locationView)
        locationView.addSubview(locationLabel)
        locationView.addSubview(addressLabel)
        locationView.backgroundColor = ZZWhiteBackground
        locationLabel.text = "位置:"
        locationLabel.textAlignment = .center
        addressLabel.text = ZZUserAddress
        addressLabel.textColor = ZZGray
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sureButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        
        locationView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(40)
            make.bottom.equalTo(sureButton.snp.top).offset(-5)
        }
        
        locationLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(50)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationLabel.snp.right)
            make.top.bottom.right.equalTo(0)
        }
    }
    
    //MARK: 确认签到
    func sureAction() {
        print("确认签到")
        saveAttendanceRecord()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
}

//MARK: Delegate
extension SignDetailViewController: MAMapViewDelegate{
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        //自定义定位小蓝点换成图片
        let rep = MAUserLocationRepresentation()
        rep.showsAccuracyRing = false
        rep.image = UIImage(named: "location")
        mapView.update(rep)

    }

}
