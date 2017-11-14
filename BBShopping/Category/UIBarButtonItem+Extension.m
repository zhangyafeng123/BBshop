//
//  UIBarButtonItem+Extension.m
//  weibo
//
//  Created by ZpyZp on 15/3/16.
//  Copyright (c) 2015年 Zpy. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem *)CreateItemWithTarget:(id)target ForAction:(SEL)action WithImage:(NSString *)Image WithHighlightImage :(NSString *)highlightImage  bageLab:(NSString *)bagetext ishide:(BOOL)hidebage
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [Btn setBackgroundImage:[UIImage imageNamed:Image] forState:UIControlStateNormal];
    [Btn setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted] ;
    [Btn addTarget:target action:action  forControlEvents:UIControlEventTouchUpInside];
    //设置尺寸
    // CGSize size = backBtn.currentBackgroundImage.size;
    // [backBtn setFrame:CGRectMake(0, 0, size.width, size.height)];
    Btn.size = Btn.currentBackgroundImage.size;
    //添加角标
    UILabel *bagelab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(Btn.frame) - 10, CGRectGetMinY(Btn.frame) - 5, 10, 10)];
    bagelab.backgroundColor = [UIColor redColor];
    bagelab.text = bagetext;
    bagelab.font = H10;
    bagelab.hidden  = hidebage;
    bagelab.textAlignment = NSTextAlignmentCenter;
    bagelab.textColor = [UIColor whiteColor];
    bagelab.layer.cornerRadius = 5;
    bagelab.layer.masksToBounds = YES;
    [Btn addSubview:bagelab];
    
    //注：一个控件出不来两个原因：1.没设置尺寸，2.没设置图片
    return [[UIBarButtonItem alloc] initWithCustomView:Btn];
}

+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}





@end
