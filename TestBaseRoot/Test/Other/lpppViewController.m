//
//  lpppViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "lpppViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface lpppViewController ()<UIGestureRecognizerDelegate>
/**
 媒体资源数据项
 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/**
 播放器对象
 */
@property (nonatomic, strong) AVPlayer *player;
/**
 视频图层对象
 */
@property (nonatomic, strong) AVPlayerLayer *avLayer;
/**
 视频播放的father视图
 */
@property (nonatomic, strong) UIView *contentView;
/**
 装载视频图层的view
 */
@property (nonatomic, strong) UIView *playerView;
/**
 暂停,继续播放按钮
 */
@property (nonatomic, strong) UIButton *pasueBtn;
/**
 已播放时长label
 */
@property (nonatomic, strong) UILabel *alreadyLabel;
/**
 播放总时长label
 */
@property (nonatomic, strong) UILabel *totalLabel;
/**
 播放进度条
 */
@property (nonatomic, strong) UISlider *sliderView;
/**
 缓冲进度条
 */
@property (nonatomic, strong) UIProgressView *progressView;
/**
 承载view,播放时隐藏,用户点击屏幕时显示
 */
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) id timeObserver;
/**
 指示器
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
/**
 错误button
 */
@property (nonatomic, strong) UIButton *errorButton;
/**
 切换横竖屏按钮
 */
@property (nonatomic, strong) UIButton *switchModelButton;
/**
 是否是横屏
 */
@property (nonatomic, assign) BOOL isFullScreen;
/**
 是否是用户手动切换
 */
@property (nonatomic, assign) BOOL isFullScreenByUser;
/**
 当前屏幕方向
 */
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;
/**
 单击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *clickTap;

@end

@implementation lpppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放初步学习";
    //加载视图
    [self setupView];
    //
    [self setAvPlayer];
    //开启
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //注册屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

#pragma mark - 创建avplayer
- (void)setAvPlayer{
    //创建一个网络视频路径
    NSString *str = @"http://data.vod.itc.cn/?rb=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/137/113/vITnGttPQmaeWrZ3mg1j9H.mp4";
    NSURL *urlStr = [NSURL URLWithString:str];
    //创建一个播放器
    self.playerItem = [[AVPlayerItem alloc] initWithURL:urlStr];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    //创建显示视频的AVPlayerLayer
    self.avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.avLayer.frame = self.playerView.bounds;
    [self.playerView.layer insertSublayer:self.avLayer atIndex:0];

    //网络视频需要监测AVPlayerItem的status属性为AVPlayerStatusReadyToPlay时,才能开始播放
    //观察Status属性，可以在加载成功之后得到视频的时长
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察loadedTimeRanges属性，可以获取缓存进度
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //观察playbackBufferEmpty属性,可以获取当前缓存区是否为空
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //观察playbackLikelyToKeepUp属性,可以获取当前缓存区是否有可播放
    [self.player.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //更新滑块进度
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        //视频的总时间
        NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        //设置滑块的当前进度
        weakSelf.sliderView.value = currentTime/totalTime;
        //设置显示的时间：以00:00:00的格式
        weakSelf.alreadyLabel.text = [weakSelf formatTimeWithTimeInterVal:currentTime];
    }];
    [self.containerView setHidden:YES];
    [self showActivityIndicatorView:YES];
}

#pragma mark - kvo观察回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay: {
                //获取视频总时长
                CMTime duration = playerItem.duration;
                //更新视频总时长label
                self.totalLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(duration)];
                self.sliderView.enabled = YES;
                [self showActivityIndicatorView:NO];
                [self.player play];
                NSLog(@"AVPlayerStatusReadyToPlay");
                break;
            }
            case AVPlayerStatusFailed:{
                [self showActivityIndicatorView:NO];
                [self showErrorButton:YES];
                NSLog(@"AVPlayerStatusFailed");
                break;
            }
            case AVPlayerStatusUnknown:
                NSLog(@"AVPlayerStatusUnknown");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        //更新显示progressView缓冲进度条的值
        self.progressView.progress = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (playerItem.playbackBufferEmpty) {
            [self showActivityIndicatorView:YES];
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (playerItem.playbackLikelyToKeepUp) {
            [self showActivityIndicatorView:NO];
            if ([self.pasueBtn.titleLabel.text isEqualToString:@"播放"]) {
                [self.player play];
            }
        }
    }
}

//转换时间格式
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600) /60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,secend];
}

#pragma mark - slider滑块相应方法
- (void)sliderViewChange{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval playTime = self.sliderView.value * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(playTime, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            if (finished) {
                [self.pasueBtn setTitle:@"播放" forState:UIControlStateNormal];
                [self.player play];
            }
        }];
    }
}

#pragma mark - 暂停/继续播放
- (void)pasueOrContinue{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        if (self.player.rate == 0.0) {
            [self.player play];
            [self.pasueBtn setTitle:@"播放" forState:UIControlStateNormal];
        }else {
            [self.player pause];
            [self.pasueBtn setTitle:@"暂停" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 点击屏幕
- (void)clickTap:(UITapGestureRecognizer *)clickTap{
    self.containerView.hidden = !self.containerView.hidden;
    if (self.containerView.hidden) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenContainerView) object:nil];
    }else{
        [self performSelector:@selector(hiddenContainerView) withObject:nil afterDelay:5];
    }
}

- (void)hiddenContainerView{
    self.containerView.hidden = YES;
}

#pragma mark - 等待指示器
- (void)showActivityIndicatorView:(BOOL)isShow{
    if (isShow) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    }else{
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    }
}

#pragma mark - errorButton
- (void)resetToPlay{
    [self showErrorButton:NO];
    [self.avLayer removeFromSuperlayer];
    self.player = nil;
    [self setAvPlayer];
}

- (void)showErrorButton:(BOOL)isShow{
    if (isShow) {
        self.containerView.hidden = YES;
        [self.playerView addSubview:self.errorButton];
        [self.errorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
    }else{
        [self.errorButton removeFromSuperview];
    }
}

#pragma mark - 屏幕旋转相关
- (void)switchScreen{
    self.isFullScreenByUser = YES;
    if (self.isFullScreen) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
    self.isFullScreenByUser = NO;
}

- (void)orientChange:(NSNotification *)notification{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint:UIInterfaceOrientationPortrait];
    }else if (orientation == UIDeviceOrientationLandscapeLeft) {
        if (self.isLandScape) {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeRight];
        }else {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
        }
    }else if (orientation == UIDeviceOrientationLandscapeRight) {
        if (self.isLandScape) {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
        }else {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeRight];
        }
    }
}
//设置竖屏
- (void)setOrientationPortraitConstraint:(UIInterfaceOrientation)orientation{
    if (orientation == self.currentOrientation) {
        return;
    }
    self.isFullScreen = NO;
    [self.playerView removeFromSuperview];
    [self.contentView addSubview:self.playerView];
    if (!self.isLandScape) {    //如果不支持自动转屏,手动切换view的transform
        [UIView animateWithDuration:0.25 animations:^{
            self.playerView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.currentOrientation = orientation;
    [self.playerView layoutIfNeeded];
    self.avLayer.frame = self.playerView.bounds;
}
//设置横屏
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation{
    if (orientation == self.currentOrientation) {
        return;
    }
    self.isFullScreen = YES;
    [self.playerView removeFromSuperview];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.playerView];
    if (self.isLandScape) {
        if (keyWindow.frame.size.width < keyWindow.frame.size.height) {
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(Device_Height));
                make.height.equalTo(@(Device_Width));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }else{
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(Device_Width));
                make.height.equalTo(@(Device_Height));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }else {
        if (self.isFullScreenByUser) {  //手动切换到横屏
            [UIView animateWithDuration:0.25 animations:^{                
                self.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }];
        }else{
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.playerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                }];
            }else if (orientation == UIInterfaceOrientationLandscapeRight) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.playerView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
                }];
            }
        }
        if (keyWindow.frame.size.width < keyWindow.frame.size.height) {
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(Device_Height));
                make.height.equalTo(@(Device_Width));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }else{
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(Device_Width));
                make.height.equalTo(@(Device_Height));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    
    self.currentOrientation = orientation;
    [self.playerView layoutIfNeeded];
    self.avLayer.frame = self.playerView.bounds;
}

#pragma mark - 创建试图
- (void)setupView{
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.playerView];
    [self.playerView addGestureRecognizer:self.clickTap];   //添加手势
    [self.playerView bringSubviewToFront:self.containerView];
    [self.playerView addSubview:self.containerView];
    [self.containerView addSubview:self.pasueBtn];
    [self.containerView addSubview:self.alreadyLabel];
    [self.containerView addSubview:self.totalLabel];
    [self.containerView addSubview:self.progressView];
    [self.containerView addSubview:self.sliderView];
    [self.playerView addSubview:self.indicatorView];
    [self.containerView addSubview:self.switchModelButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(200);
    }];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.pasueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.height.mas_equalTo(30);
    }];
    [self.alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pasueBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.pasueBtn);
    }];
    [self.switchModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.pasueBtn);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.switchModelButton.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.pasueBtn);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alreadyLabel.mas_right).offset(6);
        make.right.mas_equalTo(self.totalLabel.mas_left).offset(-6);
        make.centerY.mas_equalTo(self.pasueBtn);
        make.height.mas_equalTo(3);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alreadyLabel.mas_right).offset(5);
        make.right.mas_equalTo(self.totalLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.progressView);
        make.height.mas_equalTo(15);
    }];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(60);
    }];
    //立即更新
    [self.view layoutIfNeeded];
}

#pragma mark - 懒加载
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
    }
    return _playerView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UIButton *)pasueBtn{
    if (!_pasueBtn) {
        _pasueBtn = [[UIButton alloc] init];
        _pasueBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_pasueBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_pasueBtn addTarget:self action:@selector(pasueOrContinue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pasueBtn;
}

- (UILabel *)alreadyLabel{
    if (!_alreadyLabel) {
        _alreadyLabel = [[UILabel alloc] init];
        _alreadyLabel.text = @"00:00:00";
        _alreadyLabel.textAlignment = NSTextAlignmentRight;
        _alreadyLabel.textColor = [UIColor whiteColor];
        _alreadyLabel.font = [UIFont systemFontOfSize:15];
    }
    return _alreadyLabel;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"00:00:00";
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.font = [UIFont systemFontOfSize:15];
    }
    return _totalLabel;
}

- (UISlider *)sliderView{
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.minimumTrackTintColor = [UIColor blueColor];
        _sliderView.maximumTrackTintColor = [UIColor clearColor];
        _sliderView.enabled = NO;
        [_sliderView setValue:0];
        [_sliderView addTarget:self action:@selector(sliderViewChange) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
    }
    return _progressView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] init];
        _indicatorView.color = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        } else {
            // Fallback on earlier versions
            _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
    }
    return _indicatorView;
}

- (UIButton *)errorButton{
    if (!_errorButton) {
        _errorButton = [[UIButton alloc] init];
        _errorButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_errorButton setTitle:@"播放错误,请点击重试" forState:UIControlStateNormal];
        [_errorButton addTarget:self action:@selector(resetToPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorButton;
}

- (UIButton *)switchModelButton{
    if (!_switchModelButton) {
        _switchModelButton = [[UIButton alloc] init];
        [_switchModelButton setTitle:@"切换" forState:UIControlStateNormal];
        [_switchModelButton addTarget:self action:@selector(switchScreen) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchModelButton;
}

- (UITapGestureRecognizer *)clickTap{
    if (!_clickTap) {
        _clickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
        _clickTap.delegate = self;
        _clickTap.numberOfTapsRequired = 1;
        _clickTap.numberOfTouchesRequired = 1;
    }
    return _clickTap;
}

#pragma mark - 支持横竖屏
- (BOOL)shouldAutorotate{
    return YES;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self.timeObserver];
    self.player = nil;
}

@end
