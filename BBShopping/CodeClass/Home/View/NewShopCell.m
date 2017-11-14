//
//  NewShopCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "NewShopCell.h"

@implementation NewShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NewShopModel *)model
{
    [self.leftImgV sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl]];
    self.titleLab.text = model.goodsName;
    self.subTitleLab.text = model.subTitle;
    self.desLab.text = model.descption;
    self.priceLab.text = [NSString stringWithFormat:@"%.2f",model.groupBuyPrice];
}

@end
