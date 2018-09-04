//
//  FAFWeChatUserInfo.m
//  FAFFramework
//
//  Created by WinterChen on 15/12/30.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import "FAFWeChatUserInfo.h"

@implementation FAFWeChatUserInfo

- (instancetype)initWithWeChatUser:(id)userInfo
{
    if (self = [super init]) {
        // 微信用户数据转用户模型(具体处理)
        [self convertWeChatDataToUserInfo:userInfo];
    }
    return self;
}


// 微信用户数据转用户模型(具体处理)
- (void)convertWeChatDataToUserInfo:(NSDictionary *)userInfo
{
    _openid = userInfo[@"openid"];
    _nickname = userInfo[@"nickname"];
    _gender = [userInfo[@"sex"] integerValue] ? @"男" : @"女";
    _province = userInfo[@"province"];
    _city = userInfo[@"city"];
    _country = userInfo[@"country"];
    _iconUrl = userInfo[@"headimgurl"];
    
}

@end
