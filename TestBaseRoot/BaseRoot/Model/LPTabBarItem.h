//
//  LPTabBarItem.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 tabbar数据项
 */
NS_ASSUME_NONNULL_BEGIN

@interface LPTabBarItem : NSObject
/**
 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 前景图片
 */
@property (nonatomic, strong) UIImage *image;
/**
 前景选中图片
 */
@property (nonatomic, strong) UIImage *imageSL;

@end

NS_ASSUME_NONNULL_END
