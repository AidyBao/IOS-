//
//  FAFUnlockView.m
//  图形解锁
//
//  Created by WinterChen on 15/12/12.
//  Copyright (c) 2015年 WinterChen. All rights reserved.
//

#import "FAFUnlockView.h"

#define MaxRow 3                //最大行数
#define MaxCol 3                //最大列数
#define ButtonWidth 50.0        //图案宽度
#define PathWidth 8.0           //路径宽度
#define DefualtRedColor 201     // 默认颜色组成
#define DefualtGreenColor 248   // 默认颜色组成
#define DefualtBlueColor 255    // 默认颜色组成
#define DefualtAlphaValue 1     //默认透明度
#define DefaultNumberColor [UIColor whiteColor]         //默认数字颜色
#define DefaultNumberFont [UIFont systemFontOfSize:20]  //默认数字font
#define ErrorMessageHeight 20      // 错误提示框高度
#define ErrorMessageMarginToBottomButton 20 //错误提示框距离button图案的距离
#define ErrorMessageAnimationTime 0.05  // 错误消息提示动画持续时间

@interface FAFUnlockView ()
{
    NSMutableArray *_buttonsArray; // 所有按钮
    NSMutableArray *_passByPointsArray; // 所有经过的点
    NSMutableArray *_passwordArray; // 输入的密码
    BOOL _endTouch;
    /*
     * 路径颜色（RGB）和透明度
     */
    CGFloat _redColor;
    CGFloat _greenColor;
    CGFloat _blueColor;
    CGFloat _alphaValue;
    
    UIImageView *_backImgView; // 背景图片view
    NSString *_checkString; // 待匹配的string
    BOOL _dismissView;      // 成功后是否让self消失
    UILabel *_errorMessage; // 错误提示框
}

@end

@implementation FAFUnlockView

#pragma mark -----系统方法
- (instancetype)init
{
    // 调用initWithFrame:方法进行完整的初始化
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 初始化数组
        _buttonsArray = [NSMutableArray array];
        _passByPointsArray = [NSMutableArray array];
        _passwordArray = [NSMutableArray array];
        
        // 设置本视图为透明色
        self.backgroundColor = [UIColor clearColor];
        // 设置默认图片和路径颜色及宽度
        [self setupDefaultValue];
        
        // 设置九宫格Button视图
        [self createButtons];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 调用绘图方法
    [self drawGraphWithPasswordArrayAndPassByPointsArray];
}

// 布局子视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置buttons的frame
    [self setupButtonsFrame];
}

#pragma mark -----点击事件拦截方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 标示绘图开始
    _endTouch = NO;
    UITouch *touch = [touches anyObject];
    // 判断首次点是否在按钮区域内
    [self didSelectPasswordButtonsWithCurrentPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchedPoint = [touch locationInView:self];
    // 无按钮选中时不显示路径，直接返回
    if (_passwordArray.count == 0)
        return;
    // 当经过的点数组元素为2时，移除最后一个点
    if (_passByPointsArray.count >= 2) {
        [_passByPointsArray removeLastObject];
    }
    // 将更新的点加入到经过的点数组中
    TouchPoint *touchPoint = [[TouchPoint alloc] init];
    touchPoint.touchPoint = touchedPoint;
    [_passByPointsArray addObject:touchPoint];
    // 判断当前点是否是按钮所在点
    [self didSelectPasswordButtonsWithCurrentPoint:touchedPoint];
    // 重新绘图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 标示绘图结束
    _endTouch = YES;
    [self setNeedsDisplay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getPasswordString];
        // 清空所有数据
        [_passByPointsArray removeAllObjects];
        [_passwordArray removeAllObjects];
        [self setNeedsDisplay];
        [self cancleAllButtonsSelectedStatus];
    });
}

#pragma mark -----自有属性方法
// 设置路径颜色
- (void)setPathColor:(UIColor *)pathColor
{
    _pathColor = pathColor;
    [_pathColor getRed:&_redColor green:&_greenColor blue:&_blueColor alpha:&_alphaValue];
}

#pragma mark -----自定义方法
#pragma mark ----------公共方法
// 添加解锁视图到superView
- (void)faf_addUnlockViewToView:(UIView *)superView
{
    // 先添加背景图片
    [self setupBackgroundImage:superView];
    // 再添加当前视图
    [superView addSubview:self];
}

// check解锁的密码和checkString匹配
- (void)faf_isEqualToString:(NSString *)checkString dismissViewWhenSuceess:(BOOL)dismiss
{
    _checkString = checkString;
    _dismissView = dismiss;
}

#pragma mark ----------私有方法
// 创建错误提示框
- (void)createErrorMessage
{
    _errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, self.buttonY - ErrorMessageHeight - ErrorMessageMarginToBottomButton, self.frame.size.width, ErrorMessageHeight)];
    [self addSubview:_errorMessage];
    _errorMessage.textAlignment = NSTextAlignmentCenter;
    _errorMessage.font = self.errorMessageFont;
    _errorMessage.textColor = self.errorMessageColor;
}

// 设置默认属性
- (void)setupDefaultValue
{
    // 设置默认图片
    self.backgroundImageName = @"background";
    self.normalImageName = @"unlock_normal";
    self.selectedImageName = @"unlock_selected";
    
    // 设置默认路径颜色和透明度
    _redColor = DefualtRedColor / 255.0;
    _greenColor = DefualtGreenColor / 255.0;
    _blueColor = DefualtBlueColor / 255.0;
    _alphaValue = DefualtAlphaValue;
    
    // 设置路径的宽度
    self.pathWidth = PathWidth;
    
    // 设置按钮的宽度
    self.buttonWidth = ButtonWidth;
    
    // 设置默认数字的font和color
    self.numberFont = DefaultNumberFont;
    self.numberColor = DefaultNumberColor;
    
    // 设置默认视图消失的动画持续时间
    self.dismissAnimationTime = 0.3;
    
    // 设置错误消息的font和color
    self.errorMessageFont = [UIFont systemFontOfSize:14];
    self.errorMessageColor = [UIColor redColor];
    
    // 设置默认支持数字重复选择
    self.numberRepeat = YES;
}

// 添加背景图片
- (void)setupBackgroundImage:(UIView *)superView
{
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.backgroundImageName]];
    backImgView.frame = [UIScreen mainScreen].bounds;
    [superView addSubview:backImgView];
    _backImgView = backImgView;
}

- (void)setupButtonsTitleColorAndFont
{
    for (UIButton *button in _buttonsArray) {
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li", button.tag] attributes:@{NSFontAttributeName : self.numberFont, NSForegroundColorAttributeName : self.numberColor}];
        [button setAttributedTitle:attributeString forState:UIControlStateNormal];
    }
}

// 根据passwordArray和passByPointsArray绘图
- (void)drawGraphWithPasswordArrayAndPassByPointsArray
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger count = 0;
    // 先遍历passwordArray设置线段的端点
    for (NSNumber *tag in _passwordArray) {
        UIButton *button = (UIButton *)[self viewWithTag:[tag integerValue]];
        // 针对第一点设置为起点，后续点设置为本条线段的终点
        count++ == 0 ? CGContextMoveToPoint(context, button.center.x, button.center.y) : CGContextAddLineToPoint(context,  button.center.x, button.center.y);
    }
    // 手势未结束时执行
    if (_endTouch == NO) {
        TouchPoint *lastPoint = [_passByPointsArray lastObject];
        CGContextAddLineToPoint(context, lastPoint.touchX, lastPoint.touchY);
    }
    // 设置线条和连接点样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    // 设置线宽和颜色
    CGContextSetLineWidth(context, self.pathWidth);
    CGContextSetRGBStrokeColor(context, _redColor, _greenColor, _blueColor, _alphaValue);
    CGContextStrokePath(context);
}

// 所有按钮取消选中状态
- (void)cancleAllButtonsSelectedStatus
{
    for (UIButton *button in _buttonsArray) {
        button.enabled = YES;
    }
}

// 判断是否选择数字键
- (void)didSelectPasswordButtonsWithCurrentPoint:(CGPoint)point
{
    for (UIButton *button in _buttonsArray) {
        if (CGRectContainsPoint(button.frame, point)) {
            // 如果允许数字重复选择（默认=YES）
            if (!self.numberRepeat) {
                for (NSNumber *tag in _passwordArray) {
                    if (button.tag == [tag integerValue]) {
                        return;
                    }
                }
            }
            if ([[_passwordArray lastObject] integerValue] != button.tag) {
                // 将选中的按钮对应的数字加入密码数组
                button.enabled = NO;
                [_passwordArray addObject:[NSNumber numberWithInteger:button.tag]];
                // 清空经过的点数组，并将最后选中按钮的中心点重新加入数组
                [_passByPointsArray removeAllObjects];
                TouchPoint *touchPoint = [[TouchPoint alloc] init];
                touchPoint.touchPoint = button.center;
                [_passByPointsArray addObject:touchPoint];
            }
        }
    }
}

// 创建九宫格按钮
- (void)createButtons
{
    for (NSInteger i = 0; i < MaxRow; i++) {
        for (NSInteger j = 0; j < MaxCol; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.tag = MaxCol * i + j + 1;
            [button setBackgroundImage:[UIImage imageNamed:self.normalImageName] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:self.selectedImageName] forState:UIControlStateDisabled];
            [self addSubview:button];
            [_buttonsArray addObject:button];
            button.userInteractionEnabled = NO;
        }
    }
}

// 设置button的Frame
- (void)setupButtonsFrame
{
    CGFloat buttonW = self.buttonWidth;
    CGFloat buttonH = buttonW;
    CGFloat margin = (self.bounds.size.width - MaxCol * buttonW) / (MaxCol + 1);
    self.buttonY = self.buttonY ?: (self.bounds.size.height - ((MaxRow - 1) * margin + buttonH * MaxRow)) * 0.5;
    for (NSInteger i = 0; i < _buttonsArray.count; i++) {
        UIButton *button = _buttonsArray[i];
        NSInteger row = i / MaxCol;
        NSInteger col = i % MaxRow;
        button.frame = CGRectMake(margin + (margin + buttonW) * col, self.buttonY + (margin + buttonH) * row, buttonW, buttonH);
        if (self.showNumber) {
            [self setupButtonsTitleColorAndFont];
        }
        button.layer.cornerRadius = buttonW * 0.5;
        button.layer.masksToBounds = YES;
    }
}

// 获取输入的密码
- (void)getPasswordString
{
    if (_passwordArray.count == 0)
        return;
    
    // 数组到字符串的转换
    NSString *passwordString = [_passwordArray componentsJoinedByString:@""];
    // 代理调用
    if ([self.delegate respondsToSelector:@selector(faf_unLockView:didGetPassword:)]) {
        [self.delegate faf_unLockView:self didGetPassword:passwordString];
    }
    // 同checkString匹配
    if ([passwordString isEqualToString:_checkString]) {
        // 匹配成功
        if (_dismissView) {
            // 活动动画结束后的X和Y值
            CGFloat backImgViewX, backImgViewY, selfX, selfY;
            [self getbackX:&backImgViewX y:&backImgViewY WithView:_backImgView];
            [self getbackX:&selfX y:&selfY WithView:self];
            // 移除view时的动画效果
            [UIView animateWithDuration:self.dismissAnimationTime animations:^{
                _backImgView.frame = CGRectMake(backImgViewX, backImgViewY, _backImgView.frame.size.width, _backImgView.frame.size.height);
                _backImgView.frame = CGRectMake(selfX, selfY, self.frame.size.width, self.frame.size.height);
            } completion:^(BOOL finished) {
                // 动画完成后移除视图并执行代理方法
                [_backImgView removeFromSuperview];
                [self removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(faf_passwordMatchSucceed)]) {
                    [self.delegate faf_passwordMatchSucceed];
                }
            }];
        }
    } else {
        // 匹配失败
        self.errorString = self.errorString ?: @"密码错误";
        if (_errorMessage == nil) {
            [self createErrorMessage];
            _errorMessage.text = self.errorString;
        } else {
            _errorMessage.hidden = NO;
        }
        [UIView animateWithDuration:ErrorMessageAnimationTime animations:^{
            _errorMessage.frame = CGRectMake(-25, _errorMessage.frame.origin.y, _errorMessage.frame.size.width, _errorMessage.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:ErrorMessageAnimationTime * 2 animations:^{
                _errorMessage.frame = CGRectMake(25, _errorMessage.frame.origin.y, _errorMessage.frame.size.width, _errorMessage.frame.size.height);
            }  completion:^(BOOL finished) {
                [UIView animateWithDuration:ErrorMessageAnimationTime animations:^{
                    _errorMessage.frame = CGRectMake(0, _errorMessage.frame.origin.y, _errorMessage.frame.size.width, _errorMessage.frame.size.height);
                }  completion:^(BOOL finished) {
                    if ([self.delegate respondsToSelector:@selector(faf_passwordMatchFailure)]) {
                        [self.delegate faf_passwordMatchFailure];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _errorMessage.hidden = YES;
                    });
                }];
            }];
        }];
    }
}

// 获得对应消失方向的X和Y值
- (void)getbackX:(CGFloat *)x y:(CGFloat *)y WithView:(UIView *)view
{
    self.dismissType = self.dismissType ?:FAFUnlockViewDismissDirectionLeft;
    switch (self.dismissType) {
        case FAFUnlockViewDismissDirectionTop:
            *x = 0;
            *y = -view.frame.size.height;
            break;
        case FAFUnlockViewDismissDirectionLeft:
            *x = -view.frame.size.width;
            *y = 0;
            break;
        case FAFUnlockViewDismissDirectionBottom:
            *x = 0;
            *y = view.frame.size.height;
            break;
        case FAFUnlockViewDismissDirectionRight:
            *x = view.frame.size.width;
            *y = 0;
            break;
        default:
            break;
    }
}

@end

#pragma mark 触摸点类实现

@implementation TouchPoint

- (void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    
    _touchX = _touchPoint.x;
    _touchY = _touchPoint.y;
}

@end
