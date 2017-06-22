//
//  ServerProvider.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
import Alamofire

public protocol TargetType {
    var method: Alamofire.HTTPMethod {get}
    var path: Alamofire.URLConvertible {get}
    var parameters: [String: AnyObject]? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var header: [String: String]? { get }
}

typealias Handler = (_ success: Bool, _ info: [String: AnyObject]?) -> Void
typealias HandlerWithDictionary = (_ success:Bool, _ info: NSDictionary?) -> Void
typealias HandlerWithArrayInfo = (_ success: Bool, _ info: NSArray?) -> Void
typealias HandlerWithString = (_ success: Bool, _ info: String?) -> Void
typealias HandlerHeader = (_ header: [NSObject: AnyObject]?) -> Void

// URL
var baseURL: String {
    return ZZHelper.isDevEvironment() ? ZZDevIP : ZZDisIP
}
//

public class ServerProvider<Target: TargetType> {
    var isPrint = true
    
    
    //MARK:
    func alamofireRequest(target: Target, completion: Handler?) {
        print("请求体\(target.parameters ?? [:])")
        print("请求头  \(target.header ?? [:])")
        Alamofire.request(target.path, method: target.method, parameters: target.parameters, encoding: target.encoding, headers: target.header).responseJSON { (response) in
            self.DebugPrint(data: response)
            // 获取状态码
            let statusCode = response.response?.statusCode ?? 502
            // 是否成功
            var isSuccess = false
            // json数据
            var dict: [String: AnyObject]? = nil
            switch response.result {
            case .success(let value):
                if let json = value as? [String: AnyObject] {
                    if statusCode == 401 {
                        
                    } else if statusCode / 100 == 2 {
                        dict = json
                        if self.isPrint {
                            print("请求返回数据:\(json)")
                        }
                        isSuccess = true
                    }
                }
            case .failure:
                break
                
            }
            if let handler = completion {
                handler(isSuccess, dict)
            }
            
        }
        
        
    }
    
    
    // MARK: 完整请求工具
    func requestReturnDictionary(target: Target, completionHeader: HandlerHeader? = nil,
                                 completion: HandlerWithDictionary?) {
        
        var responseHead: [NSObject: AnyObject]?
        
        Alamofire.request(target.path,method: target.method, parameters: target.parameters, encoding: target.encoding, headers: target.header).responseJSON { (response) in
            print("请求体\(target.parameters ?? [:])")
            self.DebugPrint(data: response)
            print(response.data ?? "GG")
//            if response.result.value != nil{
//                print("Json:\(response.result.value ?? [:]) ")
//            }
            responseHead = response.response?.allHeaderFields as [NSObject : AnyObject]?
            var result = false
            var info: NSDictionary?
            let code = response.response?.statusCode ?? 502
//            print(code)
            switch response.result {
            case .success(let json):
                info = json as? NSDictionary
                if info?["status"] as! NSNumber == 511 {
                    // token失效 自动登出
//                    let vc = RemindViewController(title: "您的账号已在别处登录")
//                    vc.dismissHandle = {
                        ZZHelper.clearUserData()
//                    }
//                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            case .failure(let err):
//                print(err)
                break
            }
            if code / 100 == 2 {
                result = true
            }
            
            if let head = completionHeader {
                head(responseHead)
            }
            if let handler = completion {
                handler(result, info)
            }
            
        }
        
        
    }
    
    func requestReturnArray(target: Target, completionHeader: HandlerHeader? = nil,
                            completion: HandlerWithArrayInfo?) {
        
        var responseHead: [NSObject: AnyObject]?
        
        
        Alamofire.request(target.path,method: target.method, parameters: target.parameters, encoding: target.encoding, headers: target.header).responseJSON { (response) in
            
            self.DebugPrint(data: response)
            responseHead = response.response?.allHeaderFields as [NSObject : AnyObject]?
            var result = false
            var info: NSArray?
            let code = response.response?.statusCode ?? 502
            switch response.result {
            case .success(let json):
                info = json as? NSArray
                if code == 401 {
                    print("被迫下线")
                } else if code / 100 == 2 {
                    result = true
                }
            case .failure:
                break
            }
            if let head = completionHeader {
                head(responseHead)
            }
            if let handler = completion {
                handler(result, info)
            }
        }
    }
    
    
    func requestReturnString(target: Target, completionHeader: HandlerHeader? = nil,
                             completion: HandlerWithString?) {
        
        var responseHead: [NSObject: AnyObject]?
        
        Alamofire.request(target.path,method: target.method, parameters: target.parameters, encoding: target.encoding, headers: target.header).responseJSON { (response) in
            
            responseHead = response.response?.allHeaderFields as [NSObject : AnyObject]?
            var result = false
            var info: String?
            let code = response.response?.statusCode ?? 502
            
            switch response.result {
            case .success(let json):
                info = String(describing: json)
                if code == 401 {
                    
                } else if code / 100 == 2 {
                    result = true
                }
                
            case .failure:
                break
            }
            
            if let head = completionHeader {
                head(responseHead)
            }
            if let handler = completion {
                handler(result, info)
            }
        }
    }
    
    func requsetWithStringAndReturnDiction(target: Target,
                                           completion: HandlerWithDictionary?) {
        
        let request: NSMutableURLRequest!
        guard let url = NSURL(string: target.path as! String) else {
            return
        }
        request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = target.method.rawValue
        if target.header != nil {
            for (key, value) in target.header! {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if target.parameters != nil {
            let str = target.parameters!["string"]! as? String
            request.httpBody = str?.data(using: String.Encoding.utf8)
        }
        
        Alamofire.request(request as! URLRequestConvertible).responseJSON { response in
            
            switch response.result {
            case .failure:
                
                if completion != nil {
                    completion!(false, nil)
                }
            case .success(let responseObject):
                let info: NSDictionary? = responseObject as? NSDictionary
                let code = response.response?.statusCode ?? 502
                if code / 100 == 2 {
                    if completion != nil {
                        completion!(true, info)
                    }
                } else if code == 401 {
                    
                }
                
            }
        }
    }
    
    
    func uploadArray(target: Target, completion: HandlerWithDictionary?) {
        let method = target.method.rawValue
        let path = target.path
        let parameters = target.parameters ?? [:]
        let headers = target.header ?? [:]
        
        let request = NSMutableURLRequest(url: NSURL(string: path as? String ?? "")! as URL)
        request.httpMethod = method
        for keyValue in headers {
            request.setValue(keyValue.1, forHTTPHeaderField: keyValue.0)
        }
        let value = parameters["uploadArray"] as? NSArray ?? []
        request.httpBody = try! JSONSerialization.data(withJSONObject: value, options: [])
        
        Alamofire.request(request as! URLRequestConvertible)
            .responseJSON { response in
                self.DebugPrint(data: response)
                var result = false
                var info: NSDictionary?
                let code = response.response?.statusCode ?? 502
                switch response.result {
                case .success(let json):
                    info = json as? NSDictionary
                    if code == 401 {
                        
                    } else if code / 100 == 2 {
                        result = true
                    }
                case .failure:
                    break
                }
                if let handler = completion {
                    handler(result, info)
                }
        }
        
        
    }
    
    // 上传图片
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    
//    "OTHER_IMAGE_LOCATIONT"  "USER_PHOTO_LOCATION_CUT"
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func upLoadImageRequest(urlString : String, params:[String:String], data: Data, fileName: String,success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["token":AppKeys.getUserToken()]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let name = params["name"]
            let refRelationCategory = params["refRelationCategory"]
            multipartFormData.append((name?.data(using: String.Encoding.utf8))!, withName: "name")
            multipartFormData.append((refRelationCategory?.data(using: String.Encoding.utf8))!, withName: "refRelationCategory")
            multipartFormData.append(data, withName: "avatar", fileName: fileName, mimeType: "image/jpeg")
            
        }, to: urlString, headers: headers) { ( encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    print("\(response)")
                    if let value = response.result.value as? [String: AnyObject] {
                        success(value)
                        let json = JSON(value)
//                        print(json)
                    }
                })
            case .failure(let encodingError):
                print(encodingError)
                failture(encodingError)
            }
        }

    }
    
    

    
    

    
}


/**
 *  为了避免utf8中文"乱码",故不用alamofire的debugprint, 自己拼装了打印体,并提供了控制开关
 */
extension ServerProvider {
    
    func DebugPrint(data: (DataResponse<Any>)) {
        guard isPrint else { return }
        if data.result != nil {
            print("[REQUEST:] \(String(describing: data.request))")
        } else {
            print("[REQUEST:] NO REQUEST")
        }
        print("[RESPONSE:] \(data.response != nil ? "\(data.response!.statusCode)" : "NO RESPONSE")")
        print("[RESULT SUCCESS:] \((data.result.value ?? "NO VALUE") )")
        if data.result.error != nil {
            print("[Error REQUEST:] \(String(describing: data.result.error))")
        } else {
            print("[Error REQUEST:] NO ERROR")
        }
        print("[TIMELINE:] \(data.timeline)")
        print("---------------------------------------------")
    }
}








