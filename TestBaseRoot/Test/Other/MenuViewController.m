//
//  MenuViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/28.
//

#import "MenuViewController.h"
#import "MenuScrollView.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    CGFloat menuViewHeight = tabarHeight;
    MenuScrollView *menuView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, Device_Width, self.view.frame.size.height-menuViewHeight) MenuData:dataArray MenuSize:CGSizeMake(kFitW(45), kFitW(45)) ScrollDirection:Vertical MenusInLine:2 MenuInList:5 MenuDelegate:self];
    [self.view addSubview:menuView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
