//
//  FAFWeiBoUserInfo.m
//  新浪微博登录
//
//  Created by WinterChen on 15/12/24.
//  Copyright (c) 2015年 WinterChen. All rights reserved.
//

#import "FAFWeiBoUserInfo.h"

@implementation FAFWeiBoUserInfo

// 新浪用户数据转微博用户模型
- (instancetype)initWithWeiBoUser:(id)userInfo
{
    if (self = [super init]) {
        [self convertWeiBoDataToUserInfo:userInfo];
    }
    return self;
}

// 新浪用户数据转微博用户模型(具体处理)
- (void)convertWeiBoDataToUserInfo:(NSDictionary *)userInfo
{
    _uid = userInfo[@"idstr"];
    _nickname = userInfo[@"name"];
    _iconUrl = userInfo[@"profile_image_url"];
    _iconUrlLarge = userInfo[@"avatar_large"];
    _iconUrlHD = userInfo[@"avatar_hd"];
    _gender = [userInfo[@"gender"] isEqualToString:@"f"] ? @"女" : @"男";
    _profileDescription = userInfo[@"description"];
    _province = [self convertProvince:userInfo[@"province"]];
    _city = [self convertCity:userInfo[@"city"] userLocation:userInfo[@"location"]];
    _focusCount = userInfo[@"friends_count"];
    _fansCount = userInfo[@"followers_count"];
    _statusesCount = userInfo[@"statuses_count"];
    _registerTime = [self convertTime:userInfo[@"created_at"]];
    _creditScore = userInfo[@"credit_score"];
    _rank = userInfo[@"urank"];
    _isSinaMember = [userInfo[@"mbtype"] integerValue] > 2 ? YES : NO;
    _sinaMemberRank = userInfo[@"mbrank"];
}

// 进行省份转码
- (NSString *)convertProvince:(NSString *)provinceCode
{
    if ([provinceCode integerValue] == 100) {
        return @"其他";
    } else if ( [provinceCode integerValue] == 400) {
        return @"海外";
    }
    NSString *newProvince = nil;
    // 获取省份编码文件
    NSString *provinceFilePath = [[NSBundle mainBundle] pathForResource:@"ProvinceCode" ofType:@"plist"];
    NSDictionary *provinceDic = [NSDictionary dictionaryWithContentsOfFile:provinceFilePath];
    // 根据省份编码获取省份名称
    newProvince = provinceDic[provinceCode];
    return newProvince;
}

// 进行城市转码
- (NSString *)convertCity:(NSString *)cityCode userLocation:(NSString *)location
{
    if ([cityCode integerValue] == 1000) {
        return @"不限";
    }
    NSString *newCity = nil;
    // 去除省份
    location = [location stringByReplacingOccurrencesOfString:_province withString:@""];
    // 去除空格
    newCity = [location stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newCity;
}

// 进行时间格式转换
- (NSString *)convertTime:(NSString *)time
{
    NSString *newTime = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MM dd HH:mm:ss Z yyyy"];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSDate *date = [formatter dateFromString:time];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    newTime = [formatter stringFromDate:date];
    return newTime;
}

@end
