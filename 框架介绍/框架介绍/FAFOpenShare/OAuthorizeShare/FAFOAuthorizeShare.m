//
//  FAFOAuthorizeShare.m
//  FAFFramework
//
//  Created by WinterChen on 15/12/26.
//  Copyright (c) 2015年 FastAndFurious. All rights reserved.
//

#import "FAFOAuthorizeShare.h"
#import "OpenShareHeader.h"
#import "FAFOAuthorizeBase.h"

#define AnimationDelay 0.25

@interface FAFOAuthorizeShare ()

// 视图相关
/**  用于暂存遮盖View */
@property (nonatomic, strong) UIControl *coverView;
/**  用于显示分享icon的View */
@property (nonatomic, strong) UIView *shareView;
/**  用于暂存shareView的显示状态的Frame */
@property (nonatomic, assign) CGRect showFrame;
/**  用于暂存shareView的隐藏状态的Frame */
@property (nonatomic, assign) CGRect hideFrame;

// 数据相关
/**  分享的标题 */
@property (nonatomic, strong) NSString *title;
/**  分享的内容 */
@property (nonatomic, strong) NSString *content;
/**  分享的链接 */
@property (nonatomic, strong) NSString *link;
/**  分享的图标 */
@property (nonatomic, strong) UIImage *image;

// 分享结果回调
/**  暂存成功回调 */
@property (nonatomic, weak) FAFOAuthorizeShareSuccess success;
/**  暂存失败回调 */
@property (nonatomic, weak) FAFOAuthorizeShareFailure failure;

@end

@implementation FAFOAuthorizeShare

#pragma mark -----自定义方法
#pragma mark ----------公共方法
// 分享内容到第三方应用
+ (void)faf_shareContentToOAuthorizeApplicationWithTitle:(NSString *)title content:(NSString *)content link:(NSString *)link image:(UIImage *)image success:(FAFOAuthorizeShareSuccess)success failure:(FAFOAuthorizeShareFailure)failure
{
    // 暂存分享数据
    [[self shareInstance] saveDataWithTitle:title content:content link:link image:image success:success failure:failure];
    // 显示分享View
    [[self shareInstance] setupSharePageView];
}

#pragma mark ----------私有方法
// 分享icon点击事件
- (void)touchButton:(UIButton *)iconButton
{
    if (iconButton.tag == 0) {        // 分享到微信好友
        [self shareToWeChat];
    } else if (iconButton.tag == 1) { // 分享到朋友圈
        [self shareToWeChatFriends];
    } else if (iconButton.tag == 2) { // 分享到微信收藏
        [self shareToWeChatCollect];
    } else if (iconButton.tag == 3) { // 分享到新浪微博
        [self shareToSinaWeiBo];
    } else if (iconButton.tag == 4) { // 分享到QQ好友
        [self shareToTencentQQ];
    } else if (iconButton.tag == 5) { // 分享到QQ空间
        [self shareToTencentQQZone];
    }
}

// 微信分享方法
- (void)shareToWeChat
{
    // 注册微信的第三方应用appkey
    [OpenShare connectWeixinWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentWeiXin]];
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title;
    message.desc = self.content;
    message.link = self.link;
    message.image = self.image;
    // 发送分享请求到微信
    [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// 微信朋友圈分享方法
- (void)shareToWeChatFriends
{
    // 注册微信的第三方应用appkey
    [OpenShare connectWeixinWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentWeiXin]];
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title;
    message.desc = self.content;
    message.link = self.link;
    message.image = self.image;
    // 发送分享请求到微信
    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// 微信收藏分享方法
- (void)shareToWeChatCollect
{
    // 注册微信的第三方应用appkey
    [OpenShare connectWeixinWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentWeiXin]];
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title;
    message.desc = self.content;
    message.link = self.link;
    message.image = self.image;
    // 发送分享请求到微信
    [OpenShare shareToWeixinFavorite:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// 新浪微博分享方法
- (void)shareToSinaWeiBo
{
    // 注册新浪微博的第三方应用appkey
    [OpenShare connectWeiboWithAppKey:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeSinaWeiBo]];
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title ?: @"title";
    message.desc = self.content ?: @"content";
    message.link = self.link;
    message.image = self.link ?(self.image?:[UIImage imageNamed:@"sinawb"]): self.image;
    // 发送分享请求到Sina微博
    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
        [self cancleShare];
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// QQ分享方法
- (void)shareToTencentQQ
{
    // 注册腾讯QQ的第三方应用appkey
    [OpenShare connectQQWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentQQ]];
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title ?: @"title";
    message.desc = self.content ?: @"content";
    message.link = self.link;
    message.image = self.link ?(self.image?:[UIImage imageNamed:@"qqIcon"]): self.image;
    // 发送分享请求到QQ好友
    [OpenShare shareToQQFriends:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
        [self cancleShare];
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// QQ空间分享方法
- (void)shareToTencentQQZone
{
    // 注册腾讯QQ的第三方应用appkey
    [OpenShare connectQQWithAppId:[FAFOAuthorizeBase checkAppKeyForType:FAFOAuthorizeTypeTencentQQ]];;
    // 组装分享内容
    OSMessage *message = [[OSMessage alloc] init];
    message.title = self.title ?: @"title";
    message.desc = self.content ?: @"content";
    message.link = [self.link containsString:@"htm"] ? self.link : nil;
    message.multimediaType = OSMultimediaTypeNews;
    message.image = self.link ?(self.image?:[UIImage imageNamed:@"qqzone"]): self.image;
    message.thumbnail = self.link ?(self.image?:[UIImage imageNamed:@"qqzone"]): self.image;
    // 发送分享请求到QQ空间
    [OpenShare shareToQQZone:message Success:^(OSMessage *message) {
        if (self.success) {
            self.success(FAFOAuthorizeShareTypeSuccess);
        }
        [self cancleShare];
    } Fail:^(OSMessage *message, NSError *error) {
        if (self.failure) {
            self.failure(FAFOAuthorizeShareTypeFailure, error);
        }
    }];
}

// 暂存分享数据
- (void)saveDataWithTitle:(NSString *)title content:(NSString *)content link:(NSString *)link image:(UIImage *)image success:(FAFOAuthorizeShareSuccess)success failure:(FAFOAuthorizeShareFailure)failure
{
    _title = title;
    _content = content;
    _link = link;
    _image = image;
    _success = success;
    _failure = failure;
}

// 创建分享页面(view)
- (void)setupSharePageView
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 获取最上层的View
    UIView *topView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    // 创建遮盖View
    UIControl *coverView = [[UIControl alloc] initWithFrame:screenRect];
    coverView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:coverView];
    [coverView addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
    _coverView = coverView;
    
    // 创建share按钮区域的View
    CGFloat margin = 20;
    CGFloat buttonW = 58;
    CGFloat cancelButtonH = 60;
    CGFloat textH = 15;
    CGRect showFrame = CGRectMake(0, screenRect.size.height - (buttonW + textH) * 2 - margin * 3 - cancelButtonH, screenRect.size.width, (buttonW + textH) * 2 + margin * 3 + cancelButtonH);
    _showFrame = showFrame;
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, screenRect.size.height, screenRect.size.width, (buttonW + textH) * 2 + margin * 3 + cancelButtonH)];
    [coverView addSubview:shareView];
    _shareView = shareView;
    
    // 创建第三方应用icon
    NSArray *iconArray = @[@"wechat", @"wechatf", @"wechatc", @"sinawb", @"qqIcon", @"qqzone"];
    [self setupOAuthorizeApplicationIconInView:shareView withIconArray:iconArray];
    
    // 创建取消按钮
    [self setupCancleButtonInView:shareView];
    
    // 动画显示shareView
    [self showShareViewWithAnimation];
}

// 动画显示shareView
- (void)showShareViewWithAnimation
{
    _hideFrame = self.shareView.frame;
    [UIView animateWithDuration:AnimationDelay animations:^{        _shareView.frame = self.showFrame;
    }];
}

// 动画隐藏shareView
- (void)hideShareViewWithAnimation
{
    _showFrame = self.shareView.frame;
    [UIView animateWithDuration:AnimationDelay animations:^{
        _shareView.frame = self.hideFrame;
    }];
}

// 创建第三方应用icon按钮
- (void)setupOAuthorizeApplicationIconInView:(UIView *)shareView withIconArray:(NSArray *)iconArray
{
    CGFloat iconButtonW = 60;
    NSInteger maxCols = 3;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - maxCols * iconButtonW) / (maxCols + 1);
    CGFloat topMargin = 10;
    for (NSInteger i = 0; i < iconArray.count; i++) {
        NSString *iconStr = iconArray[i];
        UIImage *iconImg = [UIImage imageNamed:iconStr];
        // 图标
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        iconButton.frame = CGRectMake(margin + (i % maxCols) * (margin + iconButtonW), topMargin * 3 + (topMargin * 3 + iconButtonW) * (i / maxCols), iconButtonW, iconButtonW);
        [iconButton setBackgroundImage:iconImg forState:UIControlStateNormal];
        iconButton.tag = i;
        [shareView addSubview:iconButton];
        [iconButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        // 文字
        CGFloat textH = 15;
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(iconButton.frame.origin.x, iconButton.frame.origin.y + iconButton.frame.size.height, iconButtonW, textH)];
        text.text = [self platformNameByIconName:iconStr];
        text.textAlignment = NSTextAlignmentCenter;
        text.font = [UIFont systemFontOfSize:12];
        text.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [shareView addSubview:text];
    }
}

// 根据icon名称返回平台名称
- (NSString *)platformNameByIconName:(NSString *)iconName
{
    if ([iconName isEqualToString:@"wechat"]) {
        return @"微信好友";
    } else if ([iconName isEqualToString:@"wechatf"]) {
        return @"微信朋友圈";
    } else if ([iconName isEqualToString:@"wechatc"]) {
        return @"微信收藏";
    } else if ([iconName isEqualToString:@"sinawb"]) {
        return @"新浪微博";
    } else if ([iconName isEqualToString:@"qqIcon"]) {
        return @"QQ好友";
    } else if ([iconName isEqualToString:@"qqzone"]) {
        return @"QQ空间";
    }
    return nil;
}

// 创建取消按钮
- (void)setupCancleButtonInView:(UIView *)shareView
{
    CGRect screenRect = [UIScreen mainScreen].bounds;
    // 创建取消按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancleButton.frame = CGRectMake(0, 0, screenRect.size.width * 0.6, 35);
    cancleButton.center = CGPointMake(screenRect.size.width * 0.5, shareView.frame.size.height - 30);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.layer.borderWidth = 0.6;
    cancleButton.layer.borderColor = [UIColor colorWithRed:17 / 255.0 green:131 / 255.0 blue:255 / 255.0 alpha:1].CGColor;
    cancleButton.layer.cornerRadius = 5;
    cancleButton.layer.masksToBounds = YES;
    [cancleButton addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleButton];
}

// 取消按钮点击事件
- (void)cancleShare
{
    [self hideShareViewWithAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AnimationDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.coverView removeFromSuperview];
    });
}

// 获取单例对象
+ (instancetype)shareInstance
{
    static FAFOAuthorizeShare *_shareManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}


@end
