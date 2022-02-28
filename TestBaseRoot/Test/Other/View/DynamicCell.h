//
//  DynamicCell.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/25.
//

#import <UIKit/UIKit.h>
#import "DynamicCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) DynamicCellModel *dynamicModel;

@end

NS_ASSUME_NONNULL_END
