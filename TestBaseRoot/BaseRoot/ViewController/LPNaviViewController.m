//
//  LPNaviViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "LPNaviViewController.h"

@interface LPNaviViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation LPNaviViewController

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor redColor];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    bar.translucent = NO;
   
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    
    if (@available(iOS 13,*)) {
        self.modalPresentationStyle  = UIModalPresentationFullScreen;
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *nav = [UINavigationBarAppearance new];
            nav.backgroundColor = [UIColor redColor];
            nav.backgroundEffect = nil;
            self.navigationBar.scrollEdgeAppearance = nav;
            self.navigationBar.standardAppearance = nav;
        }
    }
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if (animated) {
        UIViewController *popController = self.viewControllers.lastObject;
        popController.hidesBottomBarWhenPushed = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        // 如果 push进来的不是第一个控制器
        if ([[self.childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
        // 隐藏tabbar
       viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
   
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

#pragma mark    UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark    UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.childViewControllers count] == 1) {
        return NO;
    }else{
        return YES;
    }
}
// 我们差不多能猜到是因为手势冲突导致的，那我们就先让 ViewController 同时接受多个手势吧。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
//运行试一试，两个问题同时解决，不过又发现了新问题，手指在滑动的时候，被 pop 的 ViewController 中的 UIScrollView 会跟着一起滚动，解决
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
