//
//  SuspendHelper.h
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
@interface SuspendHelper : NSObject

//按钮点击是发送通知
//SearchButton
+ (UIButton *)searchButtonCreate:(UIColor *)backColor;
//首页搜索
+(UIButton *)searchHomeCreate:(UIColor *)backGroundcolor;
//进入购物车界面悬浮按钮
+(UIButton *)shoppingButtonCreate;
//返回顶部悬浮按钮
+(UIButton *)backToTopButtonCreate;


@end
