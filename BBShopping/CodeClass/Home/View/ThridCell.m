//
//  ThridCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ThridCell.h"

@implementation ThridCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (IBAction)buttonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(buyBtnAction:)]) {
        [self.delegate buyBtnAction:self];
    }
}


-(void)setModel:(SubModel *)model
{
    [self.BigImage sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl]];
    self.titleLab.text = model.goodsName;
    self.subTitleLab.text = model.subTitle;
    self.price.text = [NSString stringWithFormat:@"¥%.2f",model.price];
}

- (void)setSearchModel:(SearchModel *)searchModel
{
    [self.BigImage sd_setImageWithURL:[NSURL URLWithString:searchModel.pic_server_url1] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    self.titleLab.text = searchModel.goods_name;
    self.subTitleLab.text = searchModel.sub_title;
    self.price.text = [NSString stringWithFormat:@"¥%.2f",[searchModel.goodsSku[@"groupBuyPrice"] floatValue]];
   
}

- (void)setDetailModel:(ClassDetailModel *)detailModel
{
    [self.BigImage sd_setImageWithURL:[NSURL URLWithString:detailModel.pic_server_url1]];
    self.titleLab.text = detailModel.goods_name;
    self.subTitleLab.text = detailModel.sub_title;
     self.price.text = [NSString stringWithFormat:@"¥%.2f",[detailModel.goodsSku[@"groupBuyPrice"] floatValue]];
}
- (void)setMoreModel:(HomeMoreModel *)moreModel
{
    [self.BigImage sd_setImageWithURL:[NSURL URLWithString:moreModel.goodsUrl]];
    self.titleLab.text = moreModel.goodsName;
    self.subTitleLab.text = moreModel.subTitle;
    self.price.text = [NSString stringWithFormat:@"¥%.2f",moreModel.price];
}

@end
