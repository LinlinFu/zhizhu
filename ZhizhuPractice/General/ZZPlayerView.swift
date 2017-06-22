//
//  ZZPlayerView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
import AVFoundation



protocol ZZPlayerViewDelegate: NSObjectProtocol {
    func zzplayer(playerView: ZZPlayerView, sliderTouchUpOut slider:UISlider)
    func zzplayer(playerView: ZZPlayerView, playAndPause playBtn:UIButton)
}


class ZZPlayerView: UIView {
    // 显示视频的视图层
    var playerLayer: AVPlayerLayer?
    var timeLabel: UILabel!
    var slider: UISlider!
    var sliding = false
    weak var delegate: ZZPlayerViewDelegate?
    var progressView: UIProgressView!
    var playBtn: UIButton!
    var playing = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-5)
        }
        
        slider = UISlider()
        self.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(50)
            make.right.equalTo(self).offset(100)
            make.height.equalTo(15)
        }
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.white
        // 在滑块圆按钮添加图片
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: UIControlState.normal)
        
        
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown), for: UIControlEvents.touchDown)
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: UIControlEvents.touchCancel)
        
        
        progressView = UIProgressView()
        progressView.backgroundColor = UIColor.lightGray
        self.insertSubview(progressView, belowSubview: slider)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(slider)
            make.centerY.equalTo(slider)
            make.height.equalTo(2)
        }
        
        progressView.tintColor = UIColor.red
        progressView.progress = 0
        
        
        playBtn = UIButton()
        self.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(slider)
            make.left.equalTo(self).offset(10)
            make.width.height.equalTo(30)
        }
        // 设置按钮图片
        playBtn.setImage(UIImage(named: "player_pause"), for: UIControlState.normal)
        // 点击事件
        playBtn.addTarget(self, action: #selector(playAndPause(btn:)) , for: UIControlEvents.touchUpInside)
    }
    
    
    func playAndPause(btn:UIButton){
        let tmp = !playing
        playing = tmp // 改变状态
        
        // 根据状态设定图片
        if playing {
            playBtn.setImage(UIImage(named: "player_pause"), for: UIControlState.normal)
        }else{
            playBtn.setImage(UIImage(named: "player_play"), for: UIControlState.normal)
        }
        
        // 代理方法
        delegate?.zzplayer(playerView: self, playAndPause: btn)
    }
    func sliderTouchDown(slider:UISlider){
        self.sliding = true
    }
    func sliderTouchUpOut(slider:UISlider){
        // TODO: -代理处理
        delegate?.zzplayer(playerView: self, sliderTouchUpOut: slider)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }

}
