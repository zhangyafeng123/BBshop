//
//  waitshouhuoCell.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/23.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "waitshouhuoCell.h"
#import "ZLabel.h"
@implementation waitshouhuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(orderSubModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.goodsPicurl] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = model.goodsName;
   
    NSString *pricestr = [NSString stringWithFormat:@"¥%.2f",model.goodsPrice];
    NSString *num = [NSString stringWithFormat:@" x %ld",model.quantity];
    
    self.priceLab.attributedText = [ZLabel attributedTextArray:@[pricestr,num] textColors:@[[UIColor blackColor],[UIColor lightGrayColor]] textfonts:@[H15,H13]];

    if (model.skupropertys) {
        self.guigeLab.text = model.skupropertys;
    } else {
        self.guigeLab.text = @"";
    }
    
}
- (void)setDetailModel:(orderDetailModel *)detailModel
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:detailModel.goodsPicurl]];
    self.titleLab.text = detailModel.goodsName;
    NSString *pricestr = [NSString stringWithFormat:@"¥%.2f",detailModel.goodsPrice];
    NSString *num = [NSString stringWithFormat:@" x %ld",detailModel.quantity];
    
    self.priceLab.attributedText = [ZLabel attributedTextArray:@[pricestr,num] textColors:@[[UIColor blackColor],[UIColor lightGrayColor]] textfonts:@[H15,H13]];
    
}
- (void)setGroupmodel:(MyGroupsubModel *)groupmodel
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:groupmodel.goodsPicurl]];
    self.titleLab.text = groupmodel.goodsName;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",groupmodel.goodsPrice];
    if (groupmodel.skupropertys) {
        self.guigeLab.text = groupmodel.skupropertys;
    } else {
        self.guigeLab.text = @"";
    }
}
- (void)setWuliuModel:(wuliuModel *)wuliuModel
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:wuliuModel.goodsPicUrl]];
    self.titleLab.text = wuliuModel.goodsName;
    NSString *pricestr = [NSString stringWithFormat:@"¥%.2f",wuliuModel.goodsPrice];
    NSString *num = [NSString stringWithFormat:@" x %ld",wuliuModel.quantity];
    
    self.priceLab.attributedText = [ZLabel attributedTextArray:@[pricestr,num] textColors:@[[UIColor blackColor],[UIColor lightGrayColor]] textfonts:@[H15,H13]];
    if ([wuliuModel.skupropertys isEqualToString:@""]) {
        self.guigeLab.text = @"";
    } else {
        self.guigeLab.text = wuliuModel.skupropertys;
    }
}
@end
