//
//  FAFNetWorkReachability.h
//  FAFFramework
//
//  Created by iecd on 15/12/15.
//  Copyright © 2015年 SnowWolfSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define kReachabilityStatus @"reachabilityStatus"
#define knetworkError @"networkError"

typedef NS_ENUM(NSInteger, FAFNetworkReachabilityStatus) {
    FAFNetworkReachabilityStatusUnknown          = -1,
    FAFNetworkReachabilityStatusNotReachable     = 0,
    FAFNetworkReachabilityStatusReachableViaWWAN = 1,
    FAFNetworkReachabilityStatusReachableViaWiFi = 2
};

@interface FAFNetWorkReachability : NSObject

/**
 *  网络状态监测，使用时监测此属性即可
 */
@property (nonatomic, assign) FAFNetworkReachabilityStatus reachabilityStatus;

/**
 *  networkError，是否在联网状态
 */
@property(nonatomic,assign)BOOL networkError;

/**
 *  单例
 *
 *  @return BMNetworkHandler的单例对象
 */
+ (FAFNetWorkReachability *)sharedInstance;

/**
 *   监听网络状态的变化
 */
+ (void)startMonitoring;

@end
