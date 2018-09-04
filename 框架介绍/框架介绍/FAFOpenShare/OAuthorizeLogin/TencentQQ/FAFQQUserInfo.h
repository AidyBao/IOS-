//
//  FAFQQUserInfo.h
//  FAFFramework
//
//  Created by WinterChen on 15/12/28.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAFQQUserInfo : NSObject

/** openid， 用户唯一标示符 */
@property (nonatomic, strong) NSString *openid;
/** province，省份 */
@property(nonatomic, copy) NSString* province;
/** city，城市 */
@property(nonatomic, copy) NSString* city;
/** nickname，昵称 */
@property(nonatomic, copy) NSString* nickname;
/** gender，性别 */
@property(nonatomic, copy) NSString* gender;
/** iconUrl，QQ头像40*40 */
@property(nonatomic, copy) NSString* iconUrl;
/** iconUrlLarge，QQ头像100*100 */
@property(nonatomic, copy) NSString* iconUrlLarge;

//前面几种属于常用属性
/** figureurl，QQ空间30*30的头像 */
@property(nonatomic, copy) NSString* figureurl;
/** figureurl_1，QQ空间50*50的头像 */
@property(nonatomic, copy) NSString* figureurl_1;
/** figureurl_2，QQ空间100*100的头像 */
@property(nonatomic, copy) NSString* figureurl_2;
/** vip,是否是vip */
@property(nonatomic, copy) NSString* vip;
/** is_yellow_vip,是否是yellow_vip */
@property(nonatomic, copy) NSString* is_yellow_vip;
/** is_yellow_year_vip,是否是yellow_vip年会员 */
@property(nonatomic, copy) NSString* is_yellow_year_vip;
/** level,等级 */
@property(nonatomic, copy) NSString* level;
/** yellow_vip_level,yellow_vip等级 */
@property(nonatomic, copy) NSString* yellow_vip_level;
/** msg,等级 */
@property(nonatomic, copy) NSString* msg;


// QQ用户数据转微博用户模型
- (instancetype)initWithQQUser:(id)userInfo openid:(NSString *)openid;

@end
