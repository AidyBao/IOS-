//
//  FAFUnlockView.h
//  图形解锁
//
//  Created by WinterChen on 15/12/12.
//  Copyright (c) 2015年 WinterChen(陈东). All rights reserved.
//

/** 
 *  ======使用说明
 *  1.实例化图形解锁对象 alloc——>init
 *  2.使用addUnlockViewToView:方法将图形解锁对象加入到父视图即可
 *
 *  ======其他自定义设置说明
 *  (1)默认图形解锁上下左右居中，Button宽度为50，可自定义宽度和图形起始Y值
 *  (2)可修改默认的背景图片和按钮normal状态和selected状态下的图片，可设置解锁路径的宽度和颜色
 *  (3)showNumber = YES，可以在图案上显示数字，同时可以设置数字的颜色numberColor和字体numberFont
 *  (4)使用isEqualToString: dismissViewWhenSuceess:方法，传入正确的密码，将匹配交给图形解锁完成，并选择匹配成功后图形解锁页面是否消失，同时可以指定消失的方向dismissType
 *  (5)密码匹配错误时弹出密码错误提示框，同时可以对提示颜色和font进行设置
 *  (6)numberRepeat = YES用于设置已经在路径中的点可否重复选择
 */

#import <UIKit/UIKit.h>

// 视图消失的方向定义
typedef enum{
    FAFUnlockViewDismissDirectionDefault,   //==FAFUnlockViewDismissDirectionLeft
    FAFUnlockViewDismissDirectionTop,       //从上侧消失
    FAFUnlockViewDismissDirectionLeft,      //从左侧消失
    FAFUnlockViewDismissDirectionBottom,    //从下侧消失
    FAFUnlockViewDismissDirectionRight      //从右侧消失
}FAFUnlockViewDismissDirection;

@class FAFUnlockView;

@protocol FAFUnlockViewDelegate <NSObject>

@optional
/**  获得当前输入的密码 */
- (void)faf_unLockView:(FAFUnlockView *)unlockView didGetPassword:(NSString *)password;

/**  密码匹配成功 */
- (void)faf_passwordMatchSucceed;

/**  密码匹配失败 */
- (void)faf_passwordMatchFailure;

@end

@interface FAFUnlockView : UIView

#pragma mark 公共属性接口
/**  背景图片名称 */
@property (nonatomic, copy) NSString *backgroundImageName;

/**  按钮normal状态的图片名称 */
@property (nonatomic, copy) NSString *normalImageName;

/**  按钮selected状态的图片名称 */
@property (nonatomic, copy) NSString *selectedImageName;

/**  解锁路径的颜色 */
@property (nonatomic, strong) UIColor *pathColor;

/**  按钮图案上数字的颜色 */
@property (nonatomic, strong) UIColor *numberColor;

/**  按钮图案上数字的font */
@property (nonatomic, strong) UIFont *numberFont;

/**  解锁路径的透明度 */
@property (nonatomic, assign) CGFloat pathAlpha;

/**  解锁路径的宽度 */
@property (nonatomic, assign) CGFloat pathWidth;

/**  按钮的宽度 */
@property (nonatomic, assign) CGFloat buttonWidth;

/**  解锁按钮的起始Y值 */
@property (nonatomic, assign) CGFloat buttonY;

/**  按钮图案上是否显示数字 */
@property (nonatomic, assign) BOOL showNumber;

/**  解锁图形消失的方向 */
@property (nonatomic, assign) FAFUnlockViewDismissDirection dismissType;

/**  解锁图形消失动画持续的时间 */
@property (nonatomic, assign) CGFloat dismissAnimationTime;

/**  密码错误提示信息 */
@property (nonatomic, strong) NSString *errorString;

/**  密码错误提示信息的颜色 */
@property (nonatomic, strong) UIColor *errorMessageColor;

/**  密码错误提示信息的font */
@property (nonatomic, strong) UIFont *errorMessageFont;

/**  设置已经在路径中的点可否重复选择 */
@property (nonatomic, assign) BOOL numberRepeat;

/**  代理，用于取回解锁的密码 */
@property (nonatomic, weak) id <FAFUnlockViewDelegate> delegate;

#pragma mark 公共方法接口
/**  添加创建的视图到SuperView上 */
- (void)faf_addUnlockViewToView:(UIView *)superView;

/**  用于check解锁的密码是否和checkString匹配，成功后根据dismiss值判断是否让解锁视图消失 */
- (void)faf_isEqualToString:(NSString *)checkString dismissViewWhenSuceess:(BOOL)dismiss;

@end


#pragma mark 触摸点类声明
@interface TouchPoint : NSObject

@property (nonatomic, readonly) CGFloat touchX;
@property (nonatomic, readonly) CGFloat touchY;
@property (nonatomic) CGPoint touchPoint;

@end
