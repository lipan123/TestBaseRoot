//
//  TableVieCellModel.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/28.
//

#import "TableVieCellModel.h"

@implementation TableVieCellModel

+ (instancetype)initTitle:(NSString *)title withViewController:(NSString *)viewController{
    TableVieCellModel *model = [[self alloc] init];
    model.title = title;
    model.viewController = viewController;
    return model;
}

@end
