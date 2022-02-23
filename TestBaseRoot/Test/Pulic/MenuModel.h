//
//  MenuModel.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/1/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 菜单model
 */
@interface MenuModel : NSObject
/**标题*/
@property (nonatomic, strong) NSString *title;
/**图片名称或地址*/
@property (nonatomic, strong) NSString *imgNameOrUrl;

@end

NS_ASSUME_NONNULL_END
