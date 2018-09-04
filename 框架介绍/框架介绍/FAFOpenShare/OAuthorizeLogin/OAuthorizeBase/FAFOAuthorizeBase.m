//
//  FAFOAuthorizeBase.m
//  FAFFramework
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import "FAFOAuthorizeBase.h"

@implementation FAFOAuthorizeBase

// 返回需要的appkey
+ (NSString *)checkAppKeyForType:(FAFOAuthorizeType)type
{
    NSString *appkey;
    switch (type) {
        case FAFOAuthorizeTypeSinaWeiBo:
            appkey = [self getAppKeyForKeyWord:@"wb"];
            break;
        case FAFOAuthorizeTypeTencentQQ:
            appkey = [self getAppKeyForKeyWord:@"tencent"];
            break;
        case FAFOAuthorizeTypeTencentWeiXin:
            appkey = [@"wx" stringByAppendingString:[self getAppKeyForKeyWord:@"wx"]];
            break;
        default:
            break;
    }
    return appkey;
}

// 遍历所有的AppKey
+ (NSString *)getAppKeyForKeyWord:(NSString *)keyWord
{
    NSArray *URLTypesArray = [NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"];
    NSArray *URLSchemesArray = [URLTypesArray lastObject][@"CFBundleURLSchemes"];
    NSString *resultString;
    for (NSString *keyString in URLSchemesArray) {
        if ([keyString containsString:keyWord]) {
            resultString = [keyString stringByReplacingOccurrencesOfString:keyWord withString:@""];
            break;
        }
    }
    return resultString;
}

@end
