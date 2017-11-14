//
//  ClassifyCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ClassifyCell.h"

@implementation ClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ClassSortModel *)model
{
    [self.bottomImageV sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    self.titleLab.text = [NSString stringWithFormat:@"%@ >",model.cateName];
}

@end
