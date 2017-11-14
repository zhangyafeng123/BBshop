//
//  shenqingCollectionViewCell.m
//  BBShopping
//
//  Created by mibo02 on 17/3/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "shenqingCollectionViewCell.h"

@implementation shenqingCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        
        [self addSubview:self.imageV];
        self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.deleteBtn.frame = CGRectMake(self.frame.size.width - 10, - 5, 10, 10);
        [self.deleteBtn setImage:[UIImage imageNamed:@"乘号"] forState:(UIControlStateNormal)];
        [self addSubview:self.deleteBtn];
    }
    return self;
}



@end
