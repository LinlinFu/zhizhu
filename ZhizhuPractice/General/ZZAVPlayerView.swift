//
//  ZZAVPlayerView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/23.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

typealias ButtonClick = (_ button: UIButton) -> Void

class ZZAVPlayerView: UIView {
    
    /**视频加载菊花**/
    var activityView: UIActivityIndicatorView!
    /**全屏切换按钮**/
    var fullScreenBtn: UIButton!
    /**播放/暂停按钮**/
    var playBtn: UIButton!
    /**当前播放时间label**/
    var currentTimeLabel: UILabel!
    /**视频slider**/
    var videoSlider: UISlider!
    /**总播放时间label**/
    var totalTimeLabel: UILabel!
    /**缓冲进度条**/
    var progessView: UIProgressView!
    /**底部backgroundView**/
    var bottomBackgroundView: UIView!
    
    
    var playBtnClick: ButtonClick!
    var fullScreenBtnClick: ButtonClick!
    
    /**
     
     init
     
     @param frame              smallFrame
     
     @param playBtnClick       播放暂停按钮block
     
     @param fullScreenBtnClick 视频播放右下角全屏和smallFrame切换
     
     return  maskView实例
     
     */
  
    init(frame: CGRect, playBtnClick: @escaping ButtonClick, fullScreenBtnClick: @escaping ButtonClick) {
        super.init(frame: frame)
        self.backgroundColor = ZZWhiteBackground
        self.isUserInteractionEnabled = true
        self.playBtnClick = playBtnClick
        self.fullScreenBtnClick = fullScreenBtnClick
        
        let hidenTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideBottomView))
        self.addGestureRecognizer(hidenTap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    // MARK: 隐藏播放条
    func hideBottomView() {
        if (self.bottomBackgroundView.isHidden) {
            self.bottomBackgroundView.isHidden = false
        }else {
            
            self.bottomBackgroundView.isHidden = true
        }
    }
    
    // MARK: 布局
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupViews()
    }
    
    func setupViews() {
        playBtn = UIButton()
        playBtn.addTarget(self, action: #selector(getter: playBtnClick), for: .touchUpInside)
        playBtn.setImage(UIImage(named: "videoPlayBtn"), for: .normal)
        playBtn.setImage(UIImage(named: "videoPauseBtn"), for: .selected)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.addSubview(activityView)
        
        bottomBackgroundView = UIView()
        bottomBackgroundView.backgroundColor = UIColor.colorWithCustom(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.addSubview(bottomBackgroundView)
        bottomBackgroundView.addSubview(playBtn)
        
        currentTimeLabel = UILabel()
        currentTimeLabel.font = UIFont.systemFont(ofSize: 11)
        currentTimeLabel.textColor = ZZWhiteBackground
        currentTimeLabel.textAlignment = .center
        currentTimeLabel.text = "00:00"
        bottomBackgroundView.addSubview(currentTimeLabel)
        
        
        totalTimeLabel = UILabel()
        totalTimeLabel.font = UIFont.systemFont(ofSize: 11)
        totalTimeLabel.textColor = ZZWhiteBackground
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.text = "00:00"
        bottomBackgroundView.addSubview(totalTimeLabel)

        
        fullScreenBtn = UIButton()
        fullScreenBtn.addTarget(self, action: #selector(getter: fullScreenBtnClick), for: .touchUpInside)
        fullScreenBtn.setImage(UIImage(named: "kr-video-player-fullscreen"), for: .normal)
        fullScreenBtn.setImage(UIImage(named: "exitFullScreen"), for: .selected)
        bottomBackgroundView.addSubview(fullScreenBtn)

        videoSlider = UISlider()
        videoSlider.setThumbImage(UIImage(named: "videoPlayerSlider"), for: .normal)
        videoSlider.minimumTrackTintColor = ZZWhiteBackground
        videoSlider.maximumTrackTintColor = UIColor.colorWithCustom(red: 0.3, green: 0.3, blue: 0.3)
        bottomBackgroundView.addSubview(videoSlider)
        
        
        progessView = UIProgressView()
        progessView.progressTintColor = UIColor.colorWithCustom(red: 1, green: 1, blue: 1, alpha: 0.6)
        progessView.trackTintColor = UIColor.clear
        bottomBackgroundView.addSubview(progessView)

    }
    
    
   //MARK: buttonClicked
    func playBtuClick(button: UIButton) {
        if self.playBtnClick != nil {
            self.playBtuClick(button: button)
        }
    }
    
    
    func fullScreenBtnCLick(button: UIButton) {
        if self.fullScreenBtnClick != nil {
            self.fullScreenBtnCLick(button: button)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = self.frame.size.width
        let heihgt: CGFloat = self.frame.size.height
        self.playBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        
        let center: CGPoint = CGPoint(x: width / 2.0, y: heihgt / 2.0)
        self.activityView.center = center
        
        self.bottomBackgroundView.frame = CGRect(x: 0, y: heihgt - 50, width: width, height: 50)
        self.currentTimeLabel.frame = CGRect(x: self.playBtn.frame.origin.x, y: 0, width: 60, height: bottomBackgroundView.frame.size.height)
        
        fullScreenBtn.frame = CGRect(x: width - 50, y: 0, width: 50, height: bottomBackgroundView.frame.size.height)

    

        let totalX: CGFloat = self.fullScreenBtn.frame.origin.x
        self.totalTimeLabel.frame = CGRect(x: totalX - 60, y: 0, width: 60, height: bottomBackgroundView.frame.size.height)
        
        let sliderWidth: CGFloat = width - (220);
        self.videoSlider.frame = CGRect(x: currentTimeLabel.frame.origin.x, y: 0, width: sliderWidth, height: bottomBackgroundView.frame.size.height)
        self.progessView.frame = CGRect(x:self.currentTimeLabel.frame.origin.x, y:24, width: sliderWidth, height: self.bottomBackgroundView.frame.size.height + 3);

    }
    
}
