//
//  MYViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "MYViewController.h"
#import "MenuScrollView.h"

@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    
    NSArray *titleArray = @[@"饮料",@"酒水类",@"洗护用品",@"生活用品",@"服装服饰",@"休闲食品",@"小家电",@"南货日杂",@"测试1",@"测试2",@"测试3"];
    NSArray *imgArray = @[@"drinksCate",@"boozeCate",@"washCate",@"liveCate",@"apparelCate",@"snackCate",@"homeAppCate",@"southCate",@"drinksCate",@"boozeCate",@"washCate"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i=0; i<titleArray.count; i++) {
        MenuModel *model = [[MenuModel alloc] init];
        model.title = titleArray[i];
        model.imgNameOrUrl = imgArray[i];
        [dataArray addObject:model];
    }
    
    MenuScrollView *menuView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, self.view.frame.size.height-83) MenuData:dataArray MenuSize:CGSizeMake(kFitW(45), kFitW(45)) ScrollDirection:None MenusInLine:2 MenuInList:0 MenuDelegate:self];
    [self.view addSubview:menuView];
}

@end
