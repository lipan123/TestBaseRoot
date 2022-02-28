//
//  TableVieCellModel.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableVieCellModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *viewController;

+(instancetype)initTitle:(NSString *)title withViewController:(NSString *)viewController;

@end

NS_ASSUME_NONNULL_END
