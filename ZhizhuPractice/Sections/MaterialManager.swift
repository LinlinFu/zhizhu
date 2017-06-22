//
//  MaterialManager.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class MaterialManager: NSObject {
    
    private var localDatas: NSMutableArray?
    
    init(localDatas: NSMutableArray?) {
        super.init()
        self.localDatas = localDatas
    }
    
    
    // 根据样式加载数据
    internal func refreshMaterialForServer(personalProfile: SiteStatusProfile, type: PlistType) {
        
        for (superIndex, localData) in localDatas!.enumerated() {
            guard var superItem = localData as? [String: AnyObject] else {
                continue
            }
            let expandType = superItem["ExpandType"] as? Bool
            // 不是扩展类型
            if expandType == false {
                guard let contents = superItem["Content"] as? [[String: AnyObject]] else {
                    continue
                }
                
                for (index, content) in contents.enumerated() {
                    let serverKey = content["ServerKey"]
                    let value = personalProfile.getValueForAssginKey(keyName: serverKey)
                    let indexPath = NSIndexPath(row: index, section: superIndex)
                    setAssginItemValue(value: value, indexPath: indexPath, superSection: nil)
                }
            }
        }
    }
    
    // 设置某项的值,并返回对应项的ServerKey
    internal func setAssginItemValue(value: String, indexPath: NSIndexPath,
                                     superSection: Int?) -> String? {
        let row = indexPath.row
        let section = indexPath.section
        if superSection != nil {
            let dic = localDatas?[superSection!] as! NSDictionary
            guard let contents = dic["Content"] as? NSMutableArray else {
                return nil
            }
            guard var items = contents[section] as? [[String: AnyObject]] else {
                return nil
            }
            var item = items[row]
            item["Value"] = value as AnyObject
            items[row] = item
            contents[section] = items
            return item["ServerKey"] as? String
        }
        let dic = localDatas?[superSection!] as! NSDictionary
        guard let contents = dic["Content"] as? NSMutableArray else {
            return nil
        }
        guard var item = contents[row] as? [String: AnyObject] else {
            return nil
        }
        item["Value"] = value as AnyObject
        contents[row] = item
        // 返回服务器对应的key
        return item["ServerKey"] as? String
    }

    
    // MARK: - 数据增加
//    // 扩展项插入一项数据，返回是否插入成功
//    internal func expandInsertSectionForData(section: Int) -> Bool {
//        let dic = localDatas?[section] as! NSDictionary
//        guard let contents = dic["Content"] as? NSMutableArray else {
//            return false
//        }
//        // 教育经历和学习经历最多5条，亲属最多4条
//        guard contents.count < 5 else {
//            return false
//        }
//        if contents.count >= 4 && (section == 2 || section == 4) {
//            return false
//        }
//        guard let content = contents[0] as? [[String: AnyObject]] else {
//            return false
//        }
//        var newContent = [[String: AnyObject]]()
//        for var item in content {
//            item["Value"] = "" as AnyObject
//            newContent.append(item)
//        }
//        contents.add(newContent)
//        return true
//    }

    
    // MARK: - 数据查询与获取
    // 判断某一项是否为选择跳转
    internal func isJumpForAssignItem(indexPath: NSIndexPath) -> Int? {
        guard let item = getAssignItem(indexPath: indexPath) else {
            return nil
        }
        guard let type = item["StyleType"] as? Int else {
            return nil
        }
        return type
    }

    
    // 获取某一项的数据
    internal func getAssignItem(indexPath: NSIndexPath) -> [String: AnyObject]? {
        let row = indexPath.row
        let section = indexPath.section
        let dic = localDatas?[section] as! NSDictionary
        guard let content = dic["Content"] as? NSArray else {
            return nil
        }
        guard let item = content[row] as? [String: AnyObject] else {
            return  nil
        }
        return item
    }
    
    // 获取section个数
    internal func getNumberOfSections() -> Int {
        guard let groups = localDatas else {
            return 0
        }
        return groups.count
    }

    // 获取当前Section中的行数
    internal func getNumberOfRowsInSection(section: Int) -> Int {
        guard let dictContent = localDatas?[section] as? [String: AnyObject] else {
            return 0
        }
        guard let expandType = dictContent["ExpandType"] as? Bool else {
            return 0
        }
        if expandType {
            return 1
        } else {
            guard let content = dictContent["Content"] as? NSArray else {
                return 0
            }
            return content.count
        }
    }
    
    // 判断是否可扩展
    internal func isExpandType(section: Int) -> Bool {
        guard let dictContent = localDatas?[section] as? [String: AnyObject] else {
            return false
        }
        guard let expandType = dictContent["ExpandType"] as? Bool else {
            return false
        }
        return expandType
    }
    
    // 获取可扩展的数据组
    internal func getExpandData(indexPath: NSIndexPath) -> NSArray? {
        let section = indexPath.section
        guard let dictContent = localDatas?[section] as? [String: AnyObject] else {
            return nil
        }
        guard let contents = dictContent["Content"] as? NSArray else {
            return nil
        }
        return contents
    }
    // 计算可扩展cell高度
    internal func expandCellHeight(indexPath: NSIndexPath) -> CGFloat {
        guard let contents = getExpandData(indexPath: indexPath) else {
            return 0
        }
        guard let content = contents[0] as? NSArray else {
            return 0
        }
        let arrayCount = contents.count
        let contentCount = content.count
        let sumCount = arrayCount * contentCount
        let cellHeight = sumCount * Int(ZZScreenWidth * 0.13)
            + (arrayCount - 1) * Int(ZZScreenWidth * 0.04)
        return CGFloat(cellHeight)
    }


}
