//
//  AppDelegate.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/21.
//

#import "AppDelegate.h"
#import "TestTabBarController.h"
#import "LPNaviViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TestTabBarController *vc = [[TestTabBarController alloc] init];
    LPNaviViewController *navc = [[LPNaviViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
