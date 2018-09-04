//
//  ViewController.m
//  框架介绍
//
//  Created by WinterChen on 16/3/3.
//  Copyright © 2016年 WinterChen. All rights reserved.
//

#import "ViewController.h"
#import "FAFOAuthorizeLogin.h"
#import "FAFOAuthorizeShare.h"
#import "UnlockViewController.h"
#import "SearchBarTableViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *buttonsDictionary;

@end

@implementation ViewController
- (NSMutableDictionary *)buttonsDictionary
{
    if (_buttonsDictionary == nil) {
        _buttonsDictionary = [NSMutableDictionary dictionary];
    }
    return _buttonsDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createButtonWithTitle:@"新浪微博登录"];
    [self createButtonWithTitle:@"腾讯QQ登录"];
    [self createButtonWithTitle:@"微信登录"];
    [self createButtonWithTitle:@"第三方应用分享"];
    [self createButtonWithTitle:@"图形解锁"];
    [self createButtonWithTitle:@"tableView"];
}

// 创建button
- (void)createButtonWithTitle:(NSString *)title
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, size.width / 3, 40);
    button.center = CGPointMake(self.buttonsDictionary.count % 2 == 0 ? size.width / 3 / 3 + button.frame.size.width * 0.5 : size.width - size.width / 3 / 3 - button.frame.size.width * 0.5, 150 + button.frame.size.height * 2 * (int)(self.buttonsDictionary.allValues.count / 2));
    [button setTitle:title forState:UIControlStateNormal];
    button.tintColor = [UIColor blackColor];
    button.backgroundColor = [UIColor orangeColor];
    button.tag = self.buttonsDictionary.count;
    [self.view addSubview:button];
    [self.buttonsDictionary setObject:@"1" forKey:button.titleLabel.text];
    [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
}

// 按钮点击事件
- (void)selectButton:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"新浪微博登录"]) { // 测试成功
        [FAFOAuthorizeLogin faf_OAuthorizeLoginSinaWeiBoWithRedirectURI:@"https://api.weibo.com/oauth2/default.html" success:^(FAFOAuthorizeLoginType type, FAFWeiBoUserInfo *userInfo) {
            
            NSLog(@"%@", userInfo);
        } failure:^(FAFOAuthorizeLoginType type, NSError *error) {
            
        }];
    } else if ([button.titleLabel.text isEqualToString:@"第三方应用分享"]) {
        [FAFOAuthorizeShare faf_shareContentToOAuthorizeApplicationWithTitle:@"框架演示" content:@"不错" link:@"https://fsh.foxconn.com" image:[UIImage imageNamed:@"qqIcon"] success:^(FAFOAuthorizeShareType type) {
            
        } failure:^(FAFOAuthorizeShareType type, NSError *error) {
            
        }];
    } else if ([button.titleLabel.text isEqualToString:@"腾讯QQ登录"]) { // 测试成功
        [FAFOAuthorizeLogin faf_OAuthorizeLoginTencentQQSuccess:^(FAFOAuthorizeLoginType type, FAFQQUserInfo *userInfo) {
            
        } failure:^(FAFOAuthorizeLoginType type, NSError *error) {
            
        }];
    } else if ([button.titleLabel.text isEqualToString:@"微信登录"]) {
        [FAFOAuthorizeLogin faf_OAuthorizeLoginWeChatSuccess:^(FAFOAuthorizeLoginType type, FAFWeChatUserInfo *userInfo) {
            
        } failure:^(FAFOAuthorizeLoginType type, NSError *error) {
            
        }];
    } else if ([button.titleLabel.text isEqualToString:@"图形解锁"]) {
        UnlockViewController *unlockVC = [[UnlockViewController alloc] init];
        [self.navigationController pushViewController:unlockVC animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    } else if ([button.titleLabel.text isEqualToString:@"tableView"]) {
        SearchBarTableViewController *vc = [[SearchBarTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    }
}

@end
