//
//  LPTabBarController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/21.
//

#import "LPTabBarController.h"

@interface LPTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation LPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setTitleColor:(UIColor *)titleColor{
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = titleColor;
    } else {
        [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColor}   forState:UIControlStateNormal];
    }
}

- (void)setTitleColorSL:(UIColor *)titleColorSL{
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:titleColorSL}   forState:UIControlStateSelected];
}

- (void)setItemArr:(NSArray<LPTabBarItem *> *)itemArr{
    _itemArr = itemArr;
}

- (void)setControllerArr:(NSArray<UIViewController *> *)controllerArr{
    [self.arr removeAllObjects];
    _controllerArr = controllerArr;
    for (NSInteger i=0; i<controllerArr.count; i++) {
        UIViewController *vc = [controllerArr objectAtIndex:i];
        LPTabBarItem *item = [_itemArr objectAtIndex:i];
        [self setUpOneChildViewController:vc withItem:item];
    }
    self.viewControllers = self.arr;
    self.selectedIndex = 0;
}

- (void)setUpOneChildViewController:(UIViewController *)viewController withItem:(LPTabBarItem *)item{
    viewController.title = item.title;
    viewController.tabBarItem.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [item.imageSL imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.arr addObject:viewController];
}

- (NSMutableArray *)arr{
    if(!_arr){
        _arr = [NSMutableArray array];
    }
    return _arr;
}

@end

