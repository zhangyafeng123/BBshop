//
//  ChosenCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ChosenCell.h"

@implementation ChosenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ChosenModel *)model
{
    
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl]];
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",model.groupBuyPrice];
    self.titleLab.text = model.goodsName;
    
}

@end
