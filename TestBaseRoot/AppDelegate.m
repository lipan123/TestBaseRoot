//
//  AppDelegate.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/21.
//

#import "AppDelegate.h"
#import "TestTabBarController.h"
#import "LPNaviViewController.h"

@interface AppDelegate ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *socket;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestTabBarController *vc = [[TestTabBarController alloc] init];
    LPNaviViewController *navc = [[LPNaviViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    [self.window makeKeyAndVisible];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.1.161:4445/app?token=gjlzn01&id=app1"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    self.socket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.socket.delegate = self;
    [self.socket open];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    NSLog(@"---程序进入后台---");
    NSLog(@"---%ld---",(long)self.socket.readyState);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"--接收到消息--%@--",(NSString *)message);
    if (message) {
        NSData *data = [@"已接收到消息" dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket sendData:data error:nil];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"----WebSocket-正在链接----");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"----WebSocket-已断开链接----");
}

@end
