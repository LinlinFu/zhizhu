//
//  NoticeViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class NoticeViewController: BaseViewController {

    
    var tableView: UITableView!
    var but: UIButton!
    var dataArray: [RemindModel] = []
    var deleteArray: [RemindModel] = []
    var isFetching = false
    var isRefreshing = false
    var offset = 0
    
    var bottomView: UIView!
    var allSelectBtu: UIButton!
    var deleteBtu: UIButton!
    
    var deleteId = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buildBottomView()
        getNoticeList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提醒"
        buildRightItem()
        buildTableView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        [bottomView, allSelectBtu, deleteBtu].forEach { (vie) in
            if vie != nil {
            vie?.removeFromSuperview()
            }
        }
    }
    
    func buildRightItem() {
        but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("编辑", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)


    }
    
    func buildBottomView() {
        bottomView = UIView(frame: CGRect(x: 0, y: ZZScreenHeight - 50, width: ZZScreenWidth, height: 50))
        bottomView.backgroundColor = ZZWhiteBackground
        let btuWidth = (ZZScreenWidth - 15) / 2.0
        allSelectBtu = UIButton(frame: CGRect(x: 5, y: 5, width: btuWidth, height: 40))
        deleteBtu = UIButton(frame: CGRect(x: btuWidth + 10, y: 5, width: btuWidth, height: 40))
        allSelectBtu.backgroundColor = ZZMainGreen
        allSelectBtu.setTitle( "全选", for: .normal)
        deleteBtu.backgroundColor = ZZRed
        deleteBtu.setTitle( "删除", for: .normal)
        allSelectBtu.addTarget(self, action: #selector(allSelectAction), for: .touchUpInside)
        deleteBtu.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        [allSelectBtu, deleteBtu].forEach { (bton) in
            bton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            bton?.setTitleColor(ZZWhiteBackground, for: .normal)
            bton?.layer.masksToBounds = true
            bton?.layer.cornerRadius = 4
            bottomView.addSubview(bton!)
        }
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(bottomView)
        bottomView.isHidden = true
    }
    



    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")
        //支持同时选中多行
        self.tableView.allowsMultipleSelectionDuringEditing = true
        view.addSubview(tableView)
        tableView.mj_header = ZZRefreshHeader(refreshingBlock: {
            if self.isFetching {
                return
            }
            self.offset = 0
            self.isRefreshing = true
            self.getNoticeList()
            
        })
        tableView.mj_footer = ZZRefreshFooter(refreshingBlock: {
            if self.isFetching {
                return
            }
            self.offset += 10
            self.getNoticeList()
            self.isRefreshing = false
        })

        
    }
    
    //MARK: 获取通知信息
    func getNoticeList() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurUserMsgs(pageSize: 10, offset: offset)) { (success, info) in
            if self.isRefreshing {
                if self.tableView != nil {
                    self.tableView.mj_header.endRefreshing()
                }
            } else {
                if self.tableView != nil {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                if self.offset == 0 {
                    self.dataArray.removeAll()
                }
                for model in JSON(info)["resultObject"]["items"].arrayValue {
                    let data = RemindModel(json: model)
                    self.dataArray.append(data)
                }

                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: 编辑
    func editAction() {
        
        self.tableView.isEditing = !self.tableView.isEditing
        if tableView.isEditing {
            but.setTitle("完成", for: .normal)
            bottomView.isHidden = false
        } else {
            but.setTitle("编辑", for: .normal)
            bottomView.isHidden = true
        }

        

    }
    
    //MARK:全选
    func allSelectAction() {
        print("---------------全选--------------")
        deleteArray.removeAll()
        for i in 0..<dataArray.count {
            let indexPath: IndexPath = IndexPath(row: i, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            deleteArray.append(dataArray[i])
        }
        for model in deleteArray {
            print(model.title)
        }
        
        
    }
    
    //MARK:删除
    func deleteAction() {
        print("---------------删除--------------")
        for model in deleteArray {
            print(model.title)
            deleteId = deleteId.appending(",\(model.id!)")
            print(deleteId)
        }
        if deleteId == "" {
            let vc = RemindViewController(title: "请选择任意通知", type: RemindType.failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .delMsgReceive(id: deleteId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                // 成功后
                let vc = RemindViewController(title: "删除成功", type: RemindType.success)
                self.present(vc, animated: true, completion: nil)
                self.but.setTitle("编辑", for: .normal)
                self.tableView.isEditing = false
                self.bottomView.isHidden = true
                self.offset = 0
                self.getNoticeList()
            }
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


   
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell") as! NoticeTableViewCell
        cell.updateData(model: dataArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {

            self.deleteArray.append(self.dataArray[indexPath.row])
            for model in deleteArray {
                print(model.title)
            }
        } else {
            let model = dataArray[indexPath.row]
            let vc = NoticeDetailViewController()
            vc.idString = model.id
            vc.receiveId = model.receiveId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
        
            let index = self.deleteArray.index(of: self.dataArray[indexPath.row])
            self.deleteArray.remove(at: index!)
            for model in deleteArray {
                print(model.title)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
}
