//
//  FAFOAuthorizeLogin.m
//  三方登录框架
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 WinterChen. All rights reserved.
//

#import "FAFOAuthorizeLogin.h"
#import "OpenShareHeader.h"
#import "FAFHttpTool.h"
#import "FAFWeChatUserInfo.h"
#import "FAFQQUserInfo.h"
#import "FAFWeiBoUserInfo.h"
#import "FAFOAuthorizeBase.h"

@implementation FAFOAuthorizeLogin
// 微信登陆授权
+ (void)faf_OAuthorizeLoginWeChatSuccess:(FAFOAuthorizeLoginWeChatSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 注册微信第三方应用的appId
    [OpenShare connectWeixinWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentWeiXin]];
    // 发送第三方应用授权请求
    [OpenShare WeixinAuth:@"snsapi_userinfo" Success:^(NSDictionary *message) {
        // 处理授权成功结果回调
        [self handleTencentWeChatAuthorizeLoginResult:message success:success failure:failure];
    } Fail:^(NSDictionary *message, NSError *error) {
        // 处理授权失败结果回调
        [self handleAuthorizeLoginFailureResult:message error:error failure:failure];
    }];
}

// 腾讯QQ登录授权
+ (void)faf_OAuthorizeLoginTencentQQSuccess:(FAFOAuthorizeLoginQQSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 注册QQ第三方应用的appId
    [OpenShare connectQQWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentQQ]];
    // 发送第三方应用授权请求
    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
        // 处理授权成功结果回调
        [self handleTencentQQAuthorizeLoginResult:message success:success failure:failure];
    } Fail:^(NSDictionary *message, NSError *error) {
        // 处理授权失败结果回调
        [self handleAuthorizeLoginFailureResult:message error:error failure:failure];
    }];
}

// 新浪微博登录授权
+ (void)faf_OAuthorizeLoginSinaWeiBoWithRedirectURI:(NSString *)redirectURI success:(FAFOAuthorizeLoginWeiBoSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 注册新浪第三方应用的appkey
    [OpenShare connectWeiboWithAppKey:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeSinaWeiBo]];
    // 发送第三方应用授权请求
    [OpenShare WeiboAuth:@"all" redirectURI:redirectURI Success:^(NSDictionary *userInfo) {
        // 处理授权成功结果回调
        [self handleSinaWeiBoAuthorizeLoginResult:userInfo success:success failure:failure];
    } Fail:^(NSDictionary *message, NSError *error) {
        // 处理授权失败结果回调
        [self handleAuthorizeLoginFailureResult:message error:error failure:failure];
    }];
}

// 处理打开第三方应用操作
+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    return YES;
}

#pragma mark ----------私有方法
// 处理授权失败回调
+ (void)handleAuthorizeLoginFailureResult:(NSDictionary *)userInfo error:(NSError *)error failure:(FAFOAuthorizeLoginFailure)failure
{
    if (failure) {
        failure(FAFOAuthorizeLoginTypeFailure, error);
    }
}

// 处理腾讯微信授权成功的回调数据
+ (void)handleTencentWeChatAuthorizeLoginResult:(NSDictionary *)userInfo success:(FAFOAuthorizeLoginWeChatSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 取回当前授权用户的accessToken和openId
    NSString *openId = userInfo[@"openid"];
    NSString *accessToken = userInfo[@"access_token"];
    // 发送获取更多个人资料的详细信息
    [FAFHttpTool faf_GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:@{@"access_token" : accessToken, @"openid" : openId} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            // 转为模型数据
            FAFWeChatUserInfo *wechatUserInfo = [[FAFWeChatUserInfo alloc] initWithWeChatUser:responseObject];
            success(FAFOAuthorizeLoginTypeSuccess, wechatUserInfo);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(FAFOAuthorizeLoginTypeFailure, error);
        }
    }];
}

// 处理腾讯QQ授权成功的回调数据
+ (void)handleTencentQQAuthorizeLoginResult:(NSDictionary *)userInfo success:(FAFOAuthorizeLoginQQSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 取回当前授权用户的accessToken和openId
    NSString *openId = userInfo[@"openid"];
    NSString *accessToken = userInfo[@"access_token"];
    // 发送获取更多个人资料的详细信息
    [FAFHttpTool faf_GET:@"https://graph.qq.com/user/get_user_info" parameters:@{@"access_token" : accessToken,  @"oauth_consumer_key" : [FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentQQ], @"openid" : openId} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            // 转为模型数据
            FAFQQUserInfo *qqUserInfo = [[FAFQQUserInfo alloc] initWithQQUser:responseObject openid:openId];
            success(FAFOAuthorizeLoginTypeSuccess, qqUserInfo);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(FAFOAuthorizeLoginTypeFailure, error);
        }
    }];
}

// 处理新浪微博授权成功的回调数据
+ (void)handleSinaWeiBoAuthorizeLoginResult:(NSDictionary *)userInfo success:(FAFOAuthorizeLoginWeiBoSuccess)success failure:(FAFOAuthorizeLoginFailure)failure
{
    // 取回当前授权用户的uid和accessToken
    NSString *userId = userInfo[@"userID"];
    NSString *accessToken = userInfo[@"accessToken"];
    // 发送获取更多个人资料的详细信息
    [FAFHttpTool faf_GET:@"https://api.weibo.com/2/users/show.json" parameters:@{@"access_token" : accessToken, @"uid" : userId} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            // 转为模型数据
            FAFWeiBoUserInfo *weiboUserInfo = [[FAFWeiBoUserInfo alloc] initWithWeiBoUser:responseObject];
            success(FAFOAuthorizeLoginTypeSuccess, weiboUserInfo);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(FAFOAuthorizeLoginTypeFailure, error);
        }
    }];
}



@end
