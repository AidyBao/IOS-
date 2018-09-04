//
//  UnlockViewController.m
//  框架介绍
//
//  Created by WinterChen on 16/3/3.
//  Copyright © 2016年 WinterChen. All rights reserved.
//

#import "UnlockViewController.h"
#import "FAFUnlockView.h"

@interface UnlockViewController () <FAFUnlockViewDelegate>

@end

@implementation UnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showUnlockView];
}

// 显示解锁图案
- (void)showUnlockView
{
    FAFUnlockView *passwordView = [[FAFUnlockView alloc] init];
    [passwordView faf_addUnlockViewToView:self.view];
    [passwordView faf_isEqualToString:@"159" dismissViewWhenSuceess:YES];
    passwordView.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark FAFUnlockViewDelegate
- (void)faf_unLockView:(FAFUnlockView *)unlockView didGetPassword:(NSString *)password
{
    NSLog(@"%@", password);
}

- (void)faf_passwordMatchSucceed
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

@end
