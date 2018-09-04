//
//  AppDelegate.m
//  框架介绍
//
//  Created by WinterChen on 16/3/3.
//  Copyright © 2016年 WinterChen. All rights reserved.
//

#import "AppDelegate.h"
#import "FAFOAuthorizeLogin.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FAFOAuthorizeLogin handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [FAFOAuthorizeLogin handleOpenURL:url];
}

@end
