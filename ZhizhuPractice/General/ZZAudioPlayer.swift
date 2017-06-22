//
//  ZZAudioPlayer.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/23.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import Foundation
import AVFoundation

/**记录当前屏幕的方向
 并没有真正的改变设备的旋转方向，项目中所有的界面都是竖屏，这里只是记录下当前的视频播放是否是全屏
 **/
enum CurrentDeviceDirection {
    case Portrait //竖屏
    case Right //向右
}
/**视频播放的状态**/
enum PlayerState {
    case Playing // 播放中
    case Stoped // 停止播放
    case Pause // 暂停播放
    case ReadyToPlay //准备好播放了
}

class ZZAudioPlayer: UIView {


    var player: AVPlayer!
    var playerState: PlayerState!
    var videoUrlStr = ""
    var playEndBlock: (()->())? = nil
    var joinTheStudyPlan: (()->())? = nil
//    var toFullScreenAction: ((fullScreenBtn: UIButton)->())? = nil

    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var smallFrame: CGRect!
    var bigFrame: CGRect!
    var videoMaskView: ZZAVPlayerView!
    var currentDevDir: CurrentDeviceDirection!
    //标记是否是用户暂停播放
    var isUserPause: Bool!
    var isDragSlider: Bool!
    //当前播放时间（单位: S）
    var currentPlayTime: Int = 0
    // 视频总时长（单位： S）
    var totalTime: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserPause = false
        self.smallFrame = frame
        self.bigFrame = CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight)
        self.playerItem = AVPlayerItem.init(url: URL(string: "")!)
        self.player = AVPlayer.init(playerItem: playerItem)
        
            // 增加下面这行可以解决iOS10兼容性问题了
            if #available(iOS 10.0, *) {
                self.player.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
            }
        self.playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.frame = frame
        layer.insertSublayer(playerLayer, at: 0)
        
//        self.videoMaskView = ZZAVPlayerView(frame: frame, playBtnClick: , fullScreenBtnClick: <#T##ButtonClick##ButtonClick##(UIButton) -> Void#>)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//        - (instancetype)initWithFrame:(CGRect)frame{
//    
//    if (self = [super initWithFrame:frame]) {
//    
//    self.isUserPause = NO;
//    self.smallFrame = frame;
//    self.bigFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    
//    
//    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
//    
//    if([[UIDevice currentDevice] systemVersion].floatValue >= 10.0){
//    //      增加下面这行可以解决iOS10兼容性问题了
//    self.player.automaticallyWaitsToMinimizeStalling = NO;
//    }
//    
//    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    
//    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    self.playerLayer.frame = frame;
//    [self.layer insertSublayer:self.playerLayer atIndex:0];
//    
//    __weak typeof(self) weakself = self;
//    self.videoMaskView = [[ZGLVideoMaskView alloc]initWithFrame:frame
//    playBtnClick:^(UIButton *playBtn) {
//    [weakself playBtnClick:playBtn];
//    } fullScreenBtnClick:^(UIButton *fullScreenBtn) {
//    
//    [weakself fullScreenClick:fullScreenBtn];
//    }];
//    
//    [self addSubview:self.videoMaskView];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
//    
//    [self setTheProgressOfPlayTime];
//    }
//    
//    return self;
//    }

    
    
    
    
    
    
    
    
    
    func toPortrait() {
        if (isPortrait() == false) {
            self.fullScreenClick(btn: self.videoMaskView.fullScreenBtn)
        }
    }
    
    // 是否是竖屏
    func isPortrait() -> Bool {
        return currentDevDir == CurrentDeviceDirection.Portrait
    }

    
    func fullScreenClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            UIView.animate(withDuration: 0.3, animations: { 
                self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI / 2.0))
            })
            currentDevDir = .Right
            frame = self.bigFrame
        } else {
            currentDevDir = .Portrait
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 2.0))
            })
            frame = self.smallFrame
        }
//        if self.toFullScreenAction != nil {
//            self.toFullScreenAction!(btn)
//        }
    }
    
    
    
}
