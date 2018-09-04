//
//  FAFWeiBoUserInfo.h
//  新浪微博登录
//
//  Created by WinterChen on 15/12/24.
//  Copyright (c) 2015年 WinterChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAFWeiBoUserInfo : NSObject

/**  微博授权登录用户的uid */
@property (nonatomic, strong, readonly) NSString *uid;
/**  微博授权登录用户的昵称 */
@property (nonatomic, strong, readonly) NSString *nickname;
/**  微博授权登录用户的个人头像 */
@property (nonatomic, strong, readonly) NSString *iconUrl;
/**  微博授权登录用户的个人头像大图 */
@property (nonatomic, strong, readonly) NSString *iconUrlLarge;
/**  微博授权登录用户的个人头像高清图 */
@property (nonatomic, strong, readonly) NSString *iconUrlHD;
/**  微博授权登录用户的性别 */
@property (nonatomic, strong, readonly) NSString *gender;
/**  微博授权登录用户的个人简介 */
@property (nonatomic, strong, readonly) NSString *profileDescription;
/**  微博授权登录用户所在的省份 */
@property (nonatomic, strong, readonly) NSString *province;
/**  微博授权登录用户所在城市 */
@property (nonatomic, strong, readonly) NSString *city;
/**  微博授权登录用户的关注数量 */
@property (nonatomic, strong, readonly) NSString *focusCount;
/**  微博授权登录用户的粉丝数 */
@property (nonatomic, strong, readonly) NSString *fansCount;
/**  微博授权登录用户的微博条数 */
@property (nonatomic, strong, readonly) NSString *statusesCount;
/**  微博授权登录用户的注册时间 */
@property (nonatomic, strong, readonly) NSString *registerTime;
/**  微博授权登录用户的积分 */
@property (nonatomic, strong, readonly) NSString *creditScore;
/**  微博用户等级（非会员） */
@property (nonatomic, strong, readonly) NSString *rank;
/**  微博授权登录用户是否为新浪会员 */
@property (nonatomic, assign, readonly) BOOL isSinaMember;
/**  微博授权登录用户会员等级 */
@property (nonatomic, strong, readonly) NSString *sinaMemberRank;



// 新浪用户数据转微博用户模型
- (instancetype)initWithWeiBoUser:(id)user;

@end
