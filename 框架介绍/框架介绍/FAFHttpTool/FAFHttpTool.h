//
//  SWSHttpTool.h
//  SWSFramework
//
//  Created by iecd on 15/12/14.
//  Copyright © 2015年 FAF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface FAFHttpTool : NSObject

/**
 *  POST回调请求方法，用法类似AF，默认超时为30S
 *
 *  @param URLStr  请求地址
 *  @param parama  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)faf_POST:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure;
/**
 *  GET回调请求方法，默认超时为30S
 *
 *  @param URLStr  请求地址
 *  @param parama  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)faf_GET:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure;

/**
 *  POST回调请求方法，带设置超时
 *
 *  @param URLStr  请求地址
 *  @param parama  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param timeOut 超时设置
 */
+ (void)faf_POST:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure timeOut:(NSTimeInterval)timeOut;

/**
 *  GET回调请求方法，带设置超时
 *
 *  @param URLStr  请求地址
 *  @param parama  请求参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *  @param timeOut 超时设置
 */
+ (void)faf_GET:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure timeOut:(NSTimeInterval)timeOut;

@end
