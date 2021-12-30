//
//  HomePageViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "HomePageViewController.h"
#import "lpppViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"王薇薇";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //加载自定义的导航栏
    [self setupNavView];
    //设置角标
    [self setTabBarBadgeValue:@"12" withIndex:0];
}

- (void)go{
    lpppViewController *vc = [[lpppViewController alloc] init];
    vc.isLandScape = NO;    //如果general中设置了支持自动旋转,负值为yes
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏自带的导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupNavView{
    self.naviView.backgroundColor = [UIColor orangeColor];
    [self.naviView.centerButton setTitle:@"自定首页" forState:UIControlStateNormal];
    [self.naviView.leftButton setTitle:@"左边哈哈哈" forState:UIControlStateNormal];
    CGSize sizeThatFits = [self.naviView.leftButton sizeThatFits:CGSizeZero];
    [self.naviView.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeThatFits.width);
        make.height.mas_equalTo(sizeThatFits.height);
    }];
    __weak typeof(self) weakSelf = self;
    [self.naviView setLeftButtonBlock:^{
        [weakSelf go];
    }];
}

@end
