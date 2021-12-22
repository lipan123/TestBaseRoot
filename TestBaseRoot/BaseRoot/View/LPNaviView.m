//
//  LPNaviView.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "LPNaviView.h"

static CGFloat BHNavBarItemW = 60.;
static CGFloat BHNavBarItemH = 40.;

@interface LPNaviView ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation LPNaviView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self lineView];
}

- (void)setShowBottomLabel:(BOOL)showBottomLabel{
    self.lineView.hidden = !showBottomLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightTextColor];
        self.lineView = lineView;
        [self.mainView addSubview:lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        [self.mainView bringSubviewToFront:lineView];
    }
    return _lineView;
}

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [UIView new];
        _mainView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainView];
        [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [_mainView.superview layoutIfNeeded];
    }
    return _mainView;
}

- (void)setTitleView:(UIView *)titleView{
    _titleView = titleView;
    if(!_titleView|| _titleView.hidden) return;
    [self.mainView addSubview:self.titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleView.frame.size.width);
        make.height.mas_equalTo(titleView.frame.size.height);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset(kStatusBarH/2);
    }];
    [_titleView.superview layoutIfNeeded];
    self.centerButton.hidden = YES;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftButton.adjustsImageWhenHighlighted = NO;
        [self.mainView addSubview:_leftButton];
        [_leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset(kStatusBarH/2);
        }];
    }
    return _leftButton;
}

- (UIView *)leftView {
    if(!_leftView) {
        _leftView = [[UIView alloc] init];
        [self.mainView addSubview:self.leftView];
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset(kStatusBarH/2);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(BHNavBarItemH);
        }];
    }
    return _leftView;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.adjustsImageWhenHighlighted = NO;
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mainView addSubview:rightButton];
        self.rightButton = rightButton;
        [_rightButton addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.width.mas_equalTo(BHNavBarItemW);
            make.height.mas_equalTo(BHNavBarItemH);
            make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset(kStatusBarH/2);
        }];
        [self.rightButton.superview layoutIfNeeded];
    }
    return _rightButton;
}

-(UIButton *)centerButton{
    if (!_centerButton) {
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
          centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        centerButton.adjustsImageWhenHighlighted = NO;
        [self.mainView addSubview:centerButton];
        self.centerButton = centerButton;
        [_centerButton addTarget:self action:@selector(clickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(BHNavBarItemH);
            make.width.mas_equalTo(100);
            make.centerY.mas_equalTo(self.mainView.mas_centerY).with.offset(kStatusBarH/2);
        }];
        [self.centerButton.superview layoutIfNeeded];
    }
    return _centerButton;
}

#pragma mark - private
- (void)clickLeftButton{
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
}

- (void)clickCenterButton{
    if (self.cenTerButtonBlock) {
        self.cenTerButtonBlock();
    }
}

- (void)clickRightButton{
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

@end
