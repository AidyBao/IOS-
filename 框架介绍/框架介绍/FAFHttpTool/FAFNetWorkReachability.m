//
//  FAFNetWorkReachability.m
//  FAFFramework
//
//  Created by iecd on 15/12/15.
//  Copyright © 2015年 SnowWolfSoftware. All rights reserved.
//

#import "FAFNetWorkReachability.h"

@implementation FAFNetWorkReachability

+ (FAFNetWorkReachability *)sharedInstance
{
    static FAFNetWorkReachability *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[FAFNetWorkReachability alloc] init];
    });
    return handler;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
    }
    return self;
}


#pragma makr - 开始监听网络连接

+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    FAFNetWorkReachability *FAFMgr = [self sharedInstance];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        [FAFMgr willChangeValueForKey:@"reachabilityStatus"];
        [FAFMgr willChangeValueForKey:@"networkError"];
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
               FAFMgr.reachabilityStatus =FAFNetworkReachabilityStatusUnknown;
                [FAFNetWorkReachability sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                FAFMgr.reachabilityStatus = FAFNetworkReachabilityStatusNotReachable;
                [FAFNetWorkReachability sharedInstance].networkError = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                FAFMgr.reachabilityStatus = FAFNetworkReachabilityStatusReachableViaWWAN;
                [FAFNetWorkReachability sharedInstance].networkError = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                FAFMgr.reachabilityStatus = FAFNetworkReachabilityStatusReachableViaWiFi;
                [FAFNetWorkReachability sharedInstance].networkError = NO;
                break;
        }
        [FAFMgr didChangeValueForKey:@"reachabilityStatus"];
        [FAFMgr didChangeValueForKey:@"networkError"];
    }];
    [mgr startMonitoring];
} 

@end
