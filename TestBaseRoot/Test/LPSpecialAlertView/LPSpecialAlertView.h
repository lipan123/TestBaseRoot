//
//  LPSpecialAlertView.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPSpecialAlertView : UIView

+ (instancetype)alertViewWithTitle:(nullable NSString *)title messageBtn:(nullable NSArray *)messageBtns otherBtn:(nullable NSArray *)otherBtns;

- (void)addToFatherView:(UIView *)view;

@property (nonatomic, copy) void(^messageBtnBlock)(NSInteger selectIndex);
@property (nonatomic, copy) void(^otherBtnBlock)(NSInteger selectIndex);

@end

NS_ASSUME_NONNULL_END
