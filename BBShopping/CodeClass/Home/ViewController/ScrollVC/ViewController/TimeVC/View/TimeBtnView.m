//
//  TimeBtnView.m
//  BBShopping
//
//  Created by mibo02 on 17/2/15.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TimeBtnView.h"

@implementation TimeBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        //
        self.buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (isiPhone5or5sor5c) {
             self.img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            self.textlab  = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 50, 20)];
              _buyBtn.frame = CGRectMake(75, 0, 70, 30);
            self.textlab.font = H10;
            self.buyBtn.titleLabel.font = H12;
        } else {
            //总高度为30
            self.img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
             _buyBtn.frame = CGRectMake(110, 0, 80,30);
             self.textlab  = [[UILabel alloc] initWithFrame:CGRectMake(25 + 5, 5, 82, 20)];
            self.textlab.font = H13;
            self.buyBtn.titleLabel.font = H13;
        }
        
        [self addSubview:self.img];
        
        self.buyBtn.layer.cornerRadius = 5;
        self.buyBtn.layer.masksToBounds = YES;
       
       
        [_buyBtn addTarget:self action:@selector(btnaction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_buyBtn];
        
       
        self.textlab.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.textlab];
      
    }
    return self;
}
- (void)btnaction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickBtnAction:)]) {
        [self.delegate clickBtnAction:sender];
    }
}

@end
