//
//  MessageBtnViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/28.
//

#import "MessageBtnViewController.h"
#import "LPSpecialAlertView.h"

@interface MessageBtnViewController ()

@end

@implementation MessageBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LPSpecialAlertView *alertView = [LPSpecialAlertView alertViewWithTitle:@"登录注册体验更多功能" messageBtn:@[@"我要注册",@"立即登录"] otherBtn:@[@"取消"]];
    alertView.messageBtnBlock = ^(NSInteger selectIndex) {
        NSLog(@"%ld",selectIndex);
    };
    alertView.otherBtnBlock = ^(NSInteger selectIndex) {
        NSLog(@"%ld",selectIndex);
    };
    [alertView addToFatherView:self.view];
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
