//
//  LPTabBarController.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/21.
//

#import <UIKit/UIKit.h>
#import "LPTabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPTabBarController : UITabBarController
/**
 标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 标题选中颜色
 */
@property (nonatomic, strong) UIColor *titleColorSL;
/**
 tabbaritem数据项
 */
@property (nonatomic, strong) NSArray<LPTabBarItem *> *itemArr;

#pragma clang diagnostic ignored"-Wobjc-property-synthesis"
/**
视图控制器数组
 */
@property(nonatomic, copy) NSArray<UIViewController *> *controllerArr;

@end

NS_ASSUME_NONNULL_END
