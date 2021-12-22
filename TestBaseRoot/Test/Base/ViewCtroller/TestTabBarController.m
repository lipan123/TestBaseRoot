//
//  TestTabBarController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "TestTabBarController.h"
#import "LPTabBarItem.h"
#import "RelaxationViewController.h"
#import "HomePageViewController.h"
#import "MYViewController.h"
#import "LPNaviViewController.h"

@interface TestTabBarController ()

@end

@implementation TestTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleColor = [UIColor blackColor];
    self.titleColorSL = [UIColor redColor];
    
    LPTabBarItem *item1 = [[LPTabBarItem alloc] init];
    item1.title = @"首页";
    item1.image = [UIImage imageNamed:@"home"];
    item1.imageSL = [UIImage imageNamed:@"home_clicked"];
    
    LPTabBarItem *item2 = [[LPTabBarItem alloc] init];
    item2.title = @"休闲";
    item2.image = [UIImage imageNamed:@"shop"];
    item2.imageSL = [UIImage imageNamed:@"shop_clicked"];
    
    LPTabBarItem *item3 = [[LPTabBarItem alloc] init];
    item3.title = @"我的";
    item3.image = [UIImage imageNamed:@"user"];
    item3.imageSL = [UIImage imageNamed:@"user_clicked"];
    
    self.itemArr = @[item1,item2,item3];
    
    HomePageViewController *vc1 = [[HomePageViewController alloc] init];
    LPNaviViewController *navc1 = [[LPNaviViewController alloc] initWithRootViewController:vc1];
    
    RelaxationViewController *vc2 = [[RelaxationViewController alloc] init];
    LPNaviViewController *navc2 = [[LPNaviViewController alloc] initWithRootViewController:vc2];
    
    MYViewController *vc3 = [[MYViewController alloc] init];
    LPNaviViewController *navc3 = [[LPNaviViewController alloc] initWithRootViewController:vc3];
    self.controllerArr = @[navc1,navc2,navc3];
}

@end
