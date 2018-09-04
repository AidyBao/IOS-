//
//  FAFQQUserInfo.m
//  FAFFramework
//
//  Created by WinterChen on 15/12/28.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import "FAFQQUserInfo.h"

@implementation FAFQQUserInfo

// QQ用户数据转用户模型
- (instancetype)initWithQQUser:(id)userInfo openid:(NSString *)openid
{
    if (self = [super init]) {
        _openid = openid;
        [self convertQQDataToUserInfo:userInfo];
    }
    return self;
}

// QQ用户数据转用户模型(具体处理)
- (void)convertQQDataToUserInfo:(NSDictionary *)userInfo
{
    _province = userInfo[@"province"];
    _city = userInfo[@"city"];
    _nickname = userInfo[@"nickname"];
    _gender = userInfo[@"gender"];
    _iconUrl = userInfo[@"figureurl_qq_1"];
    _iconUrlLarge = userInfo[@"figureurl_qq_2"];
    _figureurl = userInfo[@"figureurl"];
    _figureurl_1 = userInfo[@"figureurl_1"];
    _figureurl_2 = userInfo[@"figureurl_2"];
    _vip = userInfo[@"vip"];
    _is_yellow_vip = userInfo[@"is_yellow_vip"];
    _is_yellow_year_vip = userInfo[@"is_yellow_year_vip"];
    _level = userInfo[@"level"];
    _yellow_vip_level = userInfo[@"yellow_vip_level"];
    _msg = userInfo[@"msg"];
}

@end
