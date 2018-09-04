//
//  AFHttpToolManager.m
//
//
//  Created by iecd on 15/10/28.
//
//

#import "FAFHttpTool.h"
#import "AFHTTPSessionManager.h"

@implementation FAFHttpTool

+ (void)faf_POST:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure
{
    FAFHttpTool *manager = [[FAFHttpTool alloc]init];
    [manager POST:URLStr parameters:parama success:success failure:failure timeOut:30 delegate:nil requestName:nil];
}

+ (void)faf_GET:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure
{
    FAFHttpTool *manager = [[FAFHttpTool alloc]init];
    [manager GET:URLStr parameters:parama success:success failure:failure timeOut:30 delegate:nil requestName:nil];
}

+ (void)faf_POST:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure timeOut:(NSTimeInterval)timeOut
{
    FAFHttpTool *manager = [[FAFHttpTool alloc]init];
    [manager POST:URLStr parameters:parama success:success failure:failure timeOut:timeOut delegate:nil requestName:nil];
}

+ (void)faf_GET:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task,id responseObject))success failure:(void(^)(NSURLSessionDataTask * task,NSError * error))failure timeOut:(NSTimeInterval)timeOut
{
    FAFHttpTool *manager = [[FAFHttpTool alloc]init];
    [manager GET:URLStr parameters:parama success:success failure:failure timeOut:timeOut delegate:nil requestName:nil];
}

/**
 *  内部方法，不公开，最终的请求都调此方法
 *
 *  @param URLStr      请求地址
 *  @param parama      请求参数
 *  @param success     成功回调
 *  @param failure     失败回调
 *  @param timeOut     超时
 *  @param delegate    代理
 *  @param requestName 请求标识（代理时有效）
 */
- (void)POST:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure timeOut:(NSTimeInterval)timeOut delegate:(id)delegate requestName:(NSString *)requestName
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeOut;
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    __weak typeof(self) weakSelf;
//    //添加session
//    NSMutableDictionary *dic = nil;
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
//    if (parama) {
//        dic = [NSMutableDictionary dictionaryWithDictionary:parama];
//        [dic setObject:[[FoxAppManager shareManagerInstance] getSessionID] forKey:@"sessionId"];
//        [dic setObject:@"ios" forKey:@"platform"];
//        [dic setObject:currentVersion forKey:@"vcode"];
//    }else if ([URLStr containsString:@"?"])
//    {
//        if ([URLStr hasSuffix:@"?"])
//            URLStr = [URLStr stringByAppendingString:[NSString stringWithFormat:@"sessionId=%@&platform=ios&vcode=%@",[[FoxAppManager shareManagerInstance] getSessionID], currentVersion]];
//        else
//            URLStr = [URLStr stringByAppendingString:[NSString stringWithFormat:@"&sessionId=%@&platform=ios&vcode=%@",[[FoxAppManager shareManagerInstance] getSessionID], currentVersion]];
//    }else
//        URLStr = [URLStr stringByAppendingString:[NSString stringWithFormat:@"?sessionId=%@&platform=ios&vcode=%@",[[FoxAppManager shareManagerInstance] getSessionID], currentVersion]];
//    
    [manager POST:URLStr parameters:parama success:^(NSURLSessionDataTask * task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(task,error);
    }];
}

/**
 *  内部方法，不公开，最终的请求都调此方法
 *
 *  @param URLStr      请求地址
 *  @param parama      请求参数
 *  @param success     成功回调
 *  @param failure     失败回调
 *  @param timeOut     超时
 *  @param delegate    代理
 *  @param requestName 请求标识（代理时有效）
 */
- (void)GET:(NSString *)URLStr parameters:(NSDictionary *)parama success:(void(^)(NSURLSessionDataTask * task, id responseObject))success failure:(void(^)(NSURLSessionDataTask * task, NSError * error))failure timeOut:(NSTimeInterval)timeOut delegate:(id)delegate requestName:(NSString *)requestName
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = timeOut;
    [manager GET:URLStr parameters:parama success:^(NSURLSessionDataTask * task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(task,error);
    }];
}


@end
