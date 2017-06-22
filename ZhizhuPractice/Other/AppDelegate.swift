//
//  AppDelegate.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
import CoreLocation

private extension Selector {
    static var CheckLoginStateAction = #selector(AppDelegate.checkLoginStatus)
}

// 全局的用户位置
var ZZUserLocation = CLLocationCoordinate2D()
// 全局用户地址
var ZZUserAddress: String = ""


// 测试版本控制 //
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // 定位
    var locationManager = AMapLocationManager()
    

    //MARK:  程序完成启动
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 启动图片提前: 1秒?????????/线程延时1秒
        
    
        buildKeyWindow()
        configThirdKeys()
        configAMaLocation()
//        networkJudgement()
        
        return true
    }

    //MARK: 根视图和页面切换
    func buildKeyWindow() {
        window = UIWindow.init(frame: ZZScreenBounds)
        window?.backgroundColor = ZZWhiteBackground
        window?.makeKeyAndVisible()
        
        checkLoginStatus()
        // 检查登录状态通知
        NotificationCenter.default.addObserver(self, selector: Selector.CheckLoginStateAction, name: AppNoti.CheckLoginState, object: nil)
        
    }
    
    //MARK: 检查登录状态
    func checkLoginStatus() {
        if AppKeys.getUserToken() == "" {  // UINavigationController(rootViewController: LoginViewController())

            self.window?.rootViewController = BaseNavigationController(rootViewController: LoginViewController())        

        } else {
            
            
            if AppKeys.getCurrentStage() == "" {
                self.window?.rootViewController = BaseNavigationController(rootViewController:StartPlanViewController())
            } else {
                self.window?.rootViewController = BaseTabBarViewController()
            }
            
//            fetchData()
//            Thread.sleep(forTimeInterval: 5.0)//延长3秒
            print("token \(AppKeys.getUserToken())")
            print("userId \(AppKeys.getUserId())")
            
        }
    }
    
    // 获取当前实习计划阶段
    func fetchData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurrentStage) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                
                let resultObject = JSON(info)["resultObject"].string
                if resultObject != nil {
//                    UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()
                    self.window?.rootViewController = BaseTabBarViewController()
                } else {
//                    UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController(rootViewController:StartPlanViewController())
                    self.window?.rootViewController = BaseNavigationController(rootViewController:StartPlanViewController())
                  
                }
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    



    //MARK: 配置第三方Key
    func configThirdKeys() {
        // 高德
        AMapServices.shared().apiKey = ZZAMapKey
    }
    
    
    //MARK: 初始化高德
    func configAMaLocation() {
        locationManager.delegate = self
        // 最小更新距离
//        locationManager.distanceFilter = 50
        // 允许返回逆地理编码信息
        locationManager.locatingWithReGeocode = true
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        locationManager.startUpdatingLocation()
    }
    
//    //MARK: 网络判断
//    func networkJudgement() {
//        let reach = Reachability(hostname: "www.baidu.com")
//        
//        reach?.reachableBlock = {(reachability) in
//            DispatchQueue.main.async(execute: { 
//                if (reachability?.isReachableViaWiFi())! {
//                    print("当前使用WiFi网络")
//                    let vc = RemindViewController(title: "当前使用WiFi网络", type: .success)
//                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                } else if (reachability?.isReachableViaWWAN())! {
//                    print("当前使用3G网络")
//                    let vc = RemindViewController(title: "当前使用3G网络", type: .success)
//                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//    
//                }
//            })
//        
//        }
//        
//        reach?.unreachableBlock = {(reachability) in
//            DispatchQueue.main.async(execute: {
//                if (reachability?.isReachableViaWiFi())! {
//                    print("没有网络连接")
//                    let vc = RemindViewController(title: "没有网络连接", type: .success)
//                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
//                }
//
//        })
//        reach?.startNotifier()
//            
//        }
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


extension AppDelegate: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
//        print("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy)")
        ZZUserLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if let reGeocode = reGeocode {
//            print("reGeocode:\(reGeocode)")
            ZZUserAddress = reGeocode.formattedAddress
            
        }
    }
}
















