//
//  waitheaderView.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/23.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "waitheaderView.h"

@implementation waitheaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.storelab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 50)];
        self.storelab.text = @"君君福利店";
        self.storelab.textAlignment = NSTextAlignmentLeft;
        self.storelab.font = H15;
        [self addSubview:self.storelab];
        
        self.rightlab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, 0, 100, 50)];
        self.rightlab.textColor = [ColorString colorWithHexString:@"#f9cd02"];
        self.rightlab.textAlignment = NSTextAlignmentRight;
        self.rightlab.text =@"等待买家收货";
        self.rightlab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.rightlab];
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 10, 60, 60)];

        [self addSubview:self.imageV];
    }
    return self;
}

@end
