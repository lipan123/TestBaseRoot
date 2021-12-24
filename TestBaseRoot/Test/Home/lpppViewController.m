//
//  lpppViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "lpppViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMTime.h>
@interface lpppViewController ()
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
 装载视频图层的view
 */
@property (nonatomic, strong) UIView *contentView;
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
 进度条
 */
@property (nonatomic, strong) UISlider *sliderView;
/**
 承载view,播放时隐藏,用户点击屏幕时显示
 */
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) id timeObserver;

@end

@implementation lpppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频播放初步学习";
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(200);
    }];
    //立即更新
    [self.view layoutIfNeeded];

    //创建一个网络视频路径
    NSString *str = @"http://data.vod.itc.cn/?rb=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/137/113/vITnGttPQmaeWrZ3mg1j9H.mp4";
    NSURL *urlStr = [NSURL URLWithString:str];
    //创建一个播放器
    self.playerItem = [[AVPlayerItem alloc] initWithURL:urlStr];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    //创建显示视频的AVPlayerLayer
    self.avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.avLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:self.avLayer];
    
    //加载视图
    [self setupView];
    
    //开始播放,本地视频直接play就行
    //网络视频需要监测AVPlayerItem的status属性为AVPlayerStatusReadyToPlay时,才能开始播放
    //观察Status属性，可以在加载成功之后得到视频的时长
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察loadedTimeRanges属性，可以获取缓存进度
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //更新滑块进度
    __weak __typeof(self) weakSelf = self;
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
                [self.player play];
                break;
            }
            case AVPlayerStatusFailed:
                break;
            case AVPlayerStatusUnknown:
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
        //更新显示slider缓冲进度条的值
        self.sliderView.value = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
    }
}

#pragma mark - slider滑块相应方法
- (void)sliderViewChange{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval playTime = self.sliderView.value * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(playTime, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
        }];
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

#pragma mark - 创建试图
- (void)setupView{
    [self.contentView bringSubviewToFront:self.containerView];
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.pasueBtn];
    [self.containerView addSubview:self.alreadyLabel];
    [self.containerView addSubview:self.totalLabel];
    [self.containerView addSubview:self.sliderView];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
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
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.pasueBtn);
    }];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alreadyLabel.mas_right).offset(5);
        make.right.mas_equalTo(self.totalLabel.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.pasueBtn);
        make.height.mas_equalTo(2);
    }];
}

#pragma mark - 懒加载
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
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
        _pasueBtn.backgroundColor = [UIColor redColor];
        [_pasueBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
    if (_sliderView) {
        _sliderView = [[UISlider alloc] init];
        _sliderView.enabled = NO;
    }
    return _sliderView;
}

- (void)dealloc{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self.timeObserver];
}

@end
