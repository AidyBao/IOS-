//
//  FAFOAuthorizeLogin.h
//  三方登录框架
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 WinterChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FAFWeiBoUserInfo, FAFQQUserInfo, FAFWeChatUserInfo;

// 结果类型
typedef enum {
    FAFOAuthorizeLoginTypeSuccess,
    FAFOAuthorizeLoginTypeFailure
}FAFOAuthorizeLoginType;

// 腾讯微信授权成功结果回调
typedef void(^FAFOAuthorizeLoginWeChatSuccess)(FAFOAuthorizeLoginType type, FAFWeChatUserInfo *userInfo);
// 腾讯QQ授权成功结果回调
typedef void(^FAFOAuthorizeLoginQQSuccess)(FAFOAuthorizeLoginType type, FAFQQUserInfo *userInfo);
// 新浪微博授权成功结果回调
typedef void(^FAFOAuthorizeLoginWeiBoSuccess)(FAFOAuthorizeLoginType type, FAFWeiBoUserInfo *userInfo);
// 授权失败结果回调
typedef void(^FAFOAuthorizeLoginFailure)(FAFOAuthorizeLoginType type, NSError *error);



@interface FAFOAuthorizeLogin : NSObject

// 微信登陆授权
+ (void)faf_OAuthorizeLoginWeChatSuccess:(FAFOAuthorizeLoginWeChatSuccess)success failure:(FAFOAuthorizeLoginFailure)failure;

// 腾讯QQ登录授权
+ (void)faf_OAuthorizeLoginTencentQQSuccess:(FAFOAuthorizeLoginQQSuccess)success failure:(FAFOAuthorizeLoginFailure)failure;

// 新浪微博登录授权
+ (void)faf_OAuthorizeLoginSinaWeiBoWithRedirectURI:(NSString *)redirectURI success:(FAFOAuthorizeLoginWeiBoSuccess)success failure:(FAFOAuthorizeLoginFailure)failure;

// 处理回调打开第三方app请求
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
