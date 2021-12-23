//
//  LPBaseViewController.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import <UIKit/UIKit.h>
#import "LPNaviView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPBaseViewController : UIViewController

@property (nonatomic, strong) LPNaviView *naviView;
/**
 加载自定义导航栏,需子类重写
 */
- (void)setupNavView;
/**
 设置tabbar角标值
 */
- (void)setTabBarBadgeValue:(NSString *)valueString  withIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
