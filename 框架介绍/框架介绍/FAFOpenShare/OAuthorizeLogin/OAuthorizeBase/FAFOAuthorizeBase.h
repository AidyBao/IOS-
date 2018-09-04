//
//  FAFOAuthorizeBase.h
//  FAFFramework
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import <Foundation/Foundation.h>


// 操作类型定义
typedef enum {
    FAFOAuthorizeTypeSinaWeiBo,
    FAFOAuthorizeTypeTencentQQ,
    FAFOAuthorizeTypeTencentWeiXin
}FAFOAuthorizeType;

@interface FAFOAuthorizeBase : NSObject


// 返回需要的appkey
+ (NSString *)checkAppKeyForType:(FAFOAuthorizeType)type;

@end
