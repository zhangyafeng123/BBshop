//
//  OrderAllCell.m
//  BBShopping
//
//  Created by mibo02 on 17/3/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "OrderAllCell.h"

@implementation OrderAllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setGroupmodel:(MyGroupsubModel *)groupmodel
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:groupmodel.goodsPicurl]];
    self.titleLab.text = groupmodel.goodsName;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",groupmodel.goodsPrice];
    if ([groupmodel.skupropertys isEqualToString:@""]) {
        
        self.guigeLab.text = @"";
    } else {
        self.guigeLab.text = groupmodel.skupropertys;
    }
}
@end
