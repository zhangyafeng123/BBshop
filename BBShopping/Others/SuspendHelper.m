//
//  SuspendHelper.m
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SuspendHelper.h"

@implementation SuspendHelper



+ (UIButton *)searchButtonCreate:(UIColor *)backColor
{
    UIButton *sender = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sender.frame = CGRectMake(55, 10, SCREEN_WIDTH - 110, 33);
    sender.layer.cornerRadius = 8;
    sender.layer.masksToBounds = YES;
    sender.backgroundColor = backColor;
    sender.alpha = 0.5;
   
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 130, 33)];
    lab.text = @"搜索商品";
    lab.textAlignment = NSTextAlignmentLeft;
    [sender addSubview:lab];
    //
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130 - 30, 6, 20, 20)];
    imageV.image = [UIImage imageNamed:@"搜索"];
    [sender addSubview:imageV];
   
    return sender;
}
//首页搜索
+(UIButton *)searchHomeCreate:(UIColor *)backGroundcolor
{
    UIButton *sender = [UIButton buttonWithType:(UIButtonTypeCustom)];
    sender.frame = CGRectMake(0, 0, SCREEN_WIDTH - 70, 35);
    
    sender.layer.cornerRadius = 8;
    sender.layer.masksToBounds = YES;
    sender.backgroundColor = backGroundcolor;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    lab.text = @"搜索商品";
    lab.textColor = [ColorString colorWithHexString:@"0e0e0e"];
    lab.textAlignment = NSTextAlignmentLeft;
    [sender addSubview:lab];
    //
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sender.frame) - 30, 6, 20, 20)];
    imageV.image = [UIImage imageNamed:@"搜索"];
    [sender addSubview:imageV];
    return sender;
    
}

//进入购物车界面悬浮按钮
+(UIButton *)shoppingButtonCreate
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UIButton *sender = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sender setImage:[UIImage imageNamed:@"首页购物车"] forState:(UIControlStateNormal)];
    sender.frame = CGRectMake(SCREEN_WIDTH - 50 - 10, SCREEN_HEIGHT - 49 - 50 - 60, 50, 50);
    [window addSubview:sender];
    return sender;
}
//返回顶部悬浮按钮
+(UIButton *)backToTopButtonCreate
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    UIButton *sender = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [sender setImage:[UIImage imageNamed:@"newbacktop"] forState:(UIControlStateNormal)];
    sender.frame = CGRectMake(SCREEN_WIDTH - 40 - 10, SCREEN_HEIGHT - 49  - 60, 30, 30);
    [window addSubview:sender];
    return sender;
}




@end
