//
//  AlbumManager.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation


typealias PictureBlock = (_ resultImage: UIImage?) -> Void
typealias UpLoadBlock = (_ isSuccess: Bool, _ imageUrl: String?) -> Void

var number: Int = 0

class AlbumManager: NSObject {
    // 环境
    var context: UIViewController?
    // 回调
    var pictureBolck: PictureBlock?
    // 是否只能选择拍照
    var isCamera = false
    
    init(context: UIViewController) {
        super.init()
        self.context = context
    }
    
    // 给图片命名
    internal static func getDateTimeString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: NSDate() as Date)
        return dateString
    }
    // 获取随机字符串 暂时不用
    internal static func randomStringWithLength(len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        let count = letters.characters.count
        for _ in 0..<count {
            let random = arc4random_uniform(UInt32(count))
            let index = letters.index(letters.startIndex, offsetBy: Int(random))
            let char = letters[index]
            randomString.append(char)
        }
        return randomString
    }
    
    // MARk: - 本地操作
    internal func startAlbumAction(isCamera: Bool, pictureBolck: @escaping PictureBlock) {
        self.pictureBolck = pictureBolck
        self.isCamera = isCamera
        
        let actionSheet: UIActionSheet
        // 如果只能拍照的话
        if isCamera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                actionSheet = UIActionSheet(title: "请选择图片来源", delegate: self,
                                            cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                            otherButtonTitles: "拍照")
                actionSheet.show(in: context!.view)
                return
            } else {
                return
            }
        }
        // 如果技能拍照又能选择相册的话 首先判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet = UIActionSheet(title: "请选择图片来源", delegate: self,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择", "拍照")
        } else {
            // 相机不可用
            actionSheet = UIActionSheet(title: "请选择图片来源", delegate: self,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择")
        }
        actionSheet.show(in: context!.view)
        
    }
    
    func showImagePickerController(sourcetype: UIImagePickerControllerSourceType,  pictureBolck: @escaping PictureBlock) {
        self.pictureBolck = pictureBolck
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = false
        pickerVC.sourceType = sourcetype
        context?.present(pickerVC, animated: true, completion: nil)
    }
    
    
}
// MARK: - UIImagePickerControllerDelegate、UINavigationControllerDelegate
extension AlbumManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            pictureBolck?(image)
//        }
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pictureBolck?(image)
        }
        
        context?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        context?.dismiss(animated: true, completion: nil)
    }
}

extension AlbumManager: UIActionSheetDelegate {
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        var sourceType: UIImagePickerControllerSourceType = .photoLibrary
        if isCamera {
            switch buttonIndex {
            case 1: // 拍照
                sourceType = .camera
            default:
                return
            }
        } else {
            switch buttonIndex {
            case 1: // 从相册选择
                sourceType = .photoLibrary
            case 2: // 拍照
                sourceType = .camera
            default:
                return
            }
        }
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        pickerVC.sourceType = sourceType
        context?.present(pickerVC, animated: true, completion: nil)
    }
}
