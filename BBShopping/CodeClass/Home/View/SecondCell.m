//
//  SecondCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "SecondCell.h"

@implementation SecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HomeModel *)model
{
    [self.backImageV sd_setImageWithURL:[NSURL URLWithString:model.adpic]];
    self.oneLab.text = model.goodsName;
    self.twolab.text = model.subTitle;
    self.threeLab.text = model.descption;
    self.priceLab.text = model.name;
    
}
@end
