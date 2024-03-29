//
//  AppLaunchTime.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/6/16.
//

#import "AppLaunchTime.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation AppLaunchTime

double __t1; //创建进程时间
double __t2; //before main
double __t3; //didfinsh

//获取进程创建时间
+ (CFAbsoluteTime)processStartTime {
    if (__t1 == 0) {
        struct kinfo_proc proInfo;
        int pid = [[NSProcessInfo processInfo] processIdentifier];
        int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
        size_t size = sizeof(proInfo);
        if (sysctl(cmd, sizeof(cmd)/sizeof(*cmd), &proInfo, &size, NULL, 0)) {
            __t1 = proInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000.0 + proInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0;
        }
    }
    return __t1;
}

//开始记录: 在didfinish中调用
+ (void)mark {
    double __t1 = [AppLaunchTime processStartTime];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (__t3 == 0) {
            __t3 = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
        }
        double pret = __t2 - __t1 / 1000;
        double didfinish = __t3 - __t2;
        double total = __t3 - __t1 / 1000;
        NSLog(@"-----App启动-----耗时:pre-main:%f",pret);
        NSLog(@"-----App启动-----耗时:didfinish:%f",didfinish);
        NSLog(@"-----App启动-----耗时:total:%f",total);
    });
}

// 构造方法在main调用前调用
// 获取pre-main()阶段的结束时间点相对容易，可以直接取main()主函数的开始执行时间点.推荐使用__attribute__((constructor)) 构建器函数的被调用时间点作为pre-main()阶段结束时间点：__t2能最大程度实现解耦：
void static __attribute__((constructor)) before_main() {
    if (__t2 == 0) {
        __t2 = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
    }
}

@end
