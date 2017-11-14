//
//  ButtonBorderColorManager.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ButtonBorderColorManager.h"

@implementation ButtonBorderColorManager

//other
+(void)setbuttonNormalbordercolor:(UIButton *)btn buttontitle:(NSString *)str
{
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:str forState:(UIControlStateNormal)];
}
//right
+(void)setbuttonbordercolor:(UIButton *)btn btntitle:(NSString *)str
{
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = [ColorString colorWithHexString:@"#f9cd02"].CGColor;
    [btn setTitleColor:[ColorString colorWithHexString:@"#f9cd02"] forState:(UIControlStateNormal)];
    [btn setTitle:str forState:(UIControlStateNormal)];
}
@end
