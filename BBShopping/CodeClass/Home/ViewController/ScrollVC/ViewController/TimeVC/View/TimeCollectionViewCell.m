//
//  TimeCollectionViewCell.m
//  BBShopping
//
//  Created by mibo02 on 17/2/5.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TimeCollectionViewCell.h"

@implementation TimeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSubModel:(SubModele *)subModel
{
    [self.leftImage sd_setImageWithURL:[NSURL URLWithString:subModel.goodsUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = subModel.goodsName;
    self.subTitleLab.text = subModel.subTitle;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",subModel.discountPrice];
  
    
    self.subpriceLab.text = [NSString stringWithFormat:@"¥%.2f",subModel.groupBuyPrice];
    self.subpriceLab.attributedText = [PriceLine priceLineMethod:self.subpriceLab.text];
    
    
}
@end
