//
//  LPNaviView.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import <UIKit/UIKit.h>

#define kStatusBarH  [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 自定义导航栏
 */
NS_ASSUME_NONNULL_BEGIN

@interface LPNaviView : UIView
/**
 背景view
 */
@property (nonatomic, strong) UIView *mainView;
/**
 左边按钮
 */
@property (nonatomic, strong) UIButton *leftButton;
/**
 左边自定义view
 */
@property (nonatomic, strong) UIView *leftView;
/**
 右边按钮
 */
@property (nonatomic, strong) UIButton *rightButton;
/**
 中间按钮
 */
@property (nonatomic, strong) UIButton *centerButton;
/**
 是否显示分割线
 */
@property (nonatomic, assign) BOOL showBottomLabel;
/**
 自定义标题
 */
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, copy) void (^leftButtonBlock)(void);
@property (nonatomic, copy) void (^cenTerButtonBlock)(void);
@property (nonatomic, copy) void (^rightButtonBlock)(void);

@end

NS_ASSUME_NONNULL_END
