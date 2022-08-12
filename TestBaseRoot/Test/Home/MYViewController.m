//
//  MYViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "MYViewController.h"
#import <objc/runtime.h>

@interface MYViewController ()

@end

@implementation MYViewController

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(hahaha)) {
        NSLog(@"resolveInstanceMethod:");
        //动态添加hahaha方法的实现
        class_addMethod(self, @selector(hahaha), class_getMethodImplementation(self, @selector(test)), "v@:");
        return YES;
    }else{
        return [super resolveInstanceMethod:sel];
    }
}

+ (void)load{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        Method test = class_getInstanceMethod(self, @selector(test));
        Method ohterTest = class_getInstanceMethod(self, @selector(ohterTest));
        method_exchangeImplementations(test, ohterTest);
    });
    
}

- (void)test{
    NSLog(@"test");
}

- (void)ohterTest{
    NSLog(@"ohterTestr");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self ohterTest];
    [self hahaha];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
}

@end
