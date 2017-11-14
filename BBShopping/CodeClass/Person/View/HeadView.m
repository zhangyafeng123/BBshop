//
//  HeadView.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame imageStr:(NSString *)btnImage nickName:(NSString *)nickname
{
    if ([super initWithFrame:frame]) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.frame];
        imageV.userInteractionEnabled = YES;
        imageV.image= [UIImage imageNamed:@"present"];
        
        [self addSubview:imageV];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        btn.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, 20, 80, 80);
        [btn setImage:[UIImage imageNamed:btnImage] forState:(UIControlStateNormal)];
        [btn sd_setImageWithURL:[NSURL URLWithString:btnImage] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"未登录"]];
        
        btn.layer.cornerRadius = 40;
        btn.layer.masksToBounds = YES;
 
        [btn addTarget:self action:@selector(actionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [imageV addSubview:btn];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 75, CGRectGetMaxY(btn.frame) + 10, 150, 20)];
        lab.text = nickname;
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [imageV addSubview:lab];
    }
    return self;
}

- (void)actionBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(selectBtnAction:)]) {
        [self.delegate selectBtnAction:btn];
    }
}
@end
