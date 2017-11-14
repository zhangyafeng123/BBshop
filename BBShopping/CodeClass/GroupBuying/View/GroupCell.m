//
//  GroupCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "GroupCell.h"
#import "GroupModel.h"
@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(GroupModel *)model
{
    
    [self.topImage  sd_setImageWithURL:[NSURL URLWithString:model.picServerUrl1]];
    
    self.firstLab.text = model.goodsName;
    if (model.subTitle) {
       self.secondLab.text = model.subTitle;
    } else {
        self.secondLab.text = @"";
    }
    
    NSString *price1str = [NSString stringWithFormat:@"%.2f",model.discountPrice];
    self.threedLab.attributedText = [ZLabel attributedTextArray:@[@"拼团价:",price1str] textColors:@[[UIColor blackColor],[UIColor redColor]] textfonts:@[H13,H20]];
    self.fourdLab.text = [NSString stringWithFormat:@"单买价：%.2f",model.groupBuyPrice];
    self.fourdLab.attributedText = [PriceLine priceLineMethod:self.fourdLab.text];
}

@end
