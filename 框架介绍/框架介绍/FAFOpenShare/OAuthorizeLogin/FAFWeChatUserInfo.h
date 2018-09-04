//
//  FAFWeChatUserInfo.h
//  FAFFramework
//
//  Created by WinterChen on 15/12/30.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAFWeChatUserInfo : NSObject


/** openid， 用户唯一标示符 */
@property (nonatomic, strong) NSString *openid;
/** nickname，昵称 */
@property(nonatomic, copy) NSString* nickname;
/** gender，性别 */
@property(nonatomic, copy) NSString* gender;
/** province，省份 */
@property(nonatomic, copy) NSString* province;
/** city，城市 */
@property(nonatomic, copy) NSString* city;
/** country，国家 */
@property(nonatomic, copy) NSString* country;
/** iconUrl，微信头像*/
@property(nonatomic, copy) NSString* iconUrl;


// 微信用户数据转用户模型
- (instancetype)initWithWeChatUser:(id)userInfo;

@end
