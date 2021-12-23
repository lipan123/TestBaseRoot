//
//  LPBaseViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "LPBaseViewController.h"

@interface LPBaseViewController ()

@end

@implementation LPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupNavView{
    [self naviView];
}

- (void)setTabBarBadgeValue:(NSString *)valueString withIndex:(NSInteger)index{
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:index];
    item.badgeValue = valueString;
}

- (LPNaviView *)naviView{
    if (!_naviView) {
        _naviView = [[LPNaviView alloc] init];
        [self.view addSubview:_naviView];
        _naviView.showBottomLabel = NO;
        [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(self.navigationController.navigationBar.frame.size.height + kStatusBarH);
        }];
        [_naviView.superview layoutIfNeeded];
    }
    return _naviView;
}

@end
