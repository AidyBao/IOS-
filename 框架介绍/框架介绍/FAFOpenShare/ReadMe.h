
//
//  ReadMe.h
//  FAFFramework
//
//  Created by WinterChen on 16/1/4.
//  Copyright (c) 2016年 FastAndFurious. All rights reserved.
//

#ifndef FAFFramework_ReadMe_h
#define FAFFramework_ReadMe_h
/**
 *
    使用说明:
    1.在Targets——>Info——>URL Types中设置第三方应用的AppId或AppKey;
    2.在AppDelegate.m中实现以下方法:
    iOS 9之后:
    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
     {
         return [FAFOAuthorizeLogin handleOpenURL:url];
     }
    iOS 9.0之前:
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        return [FAFOAuthorizeLogin handleOpenURL:url];
    }
    3.目前此框架可实现微博和QQ的三方授权登录（微信授权登录接口可用，但暂不能授权成功）
    4.实现微博和QQ授权登录只需导入FAFOAuthorizeLogin.h头文件，再调用相应登录授权方法即可
    5.实现微博、微信和QQ分享只需导入FAFOAuthorizeShare.h头文件，再调用分享方法即可
 *
 */

#endif
