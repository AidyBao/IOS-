//
//  FAFOAuthorizeShare.h
//  FAFFramework
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 结果类型
typedef enum {
    FAFOAuthorizeShareTypeSuccess,
    FAFOAuthorizeShareTypeFailure
}FAFOAuthorizeShareType;

// 分享成功结果回调
typedef void(^FAFOAuthorizeShareSuccess)(FAFOAuthorizeShareType type);
// 分享失败结果回调
typedef void(^FAFOAuthorizeShareFailure)(FAFOAuthorizeShareType type, NSError *error);

@interface FAFOAuthorizeShare : NSObject

/** 分享内容到第三方应用
 *
 *  @pragam title       为必须传入的参数
 *  @pragam link        不为nil时，@pragam image为app图标，且不能为nil；
 *  @pragam link        为nil时，@pragam image为分享的图片(可为nil)，@pargam content会被忽略掉；
 *
 */
+ (void)faf_shareContentToOAuthorizeApplicationWithTitle:(NSString *)title content:(NSString *)content link:(NSString *)link image:(UIImage *)image success:(FAFOAuthorizeShareSuccess)success failure:(FAFOAuthorizeShareFailure)failure;

@end
