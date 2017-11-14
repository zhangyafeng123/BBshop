//
//  wuliuCell.m
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "wuliuCell.h"

@implementation wuliuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(wuliuModel *)model
{
    self.onelab.text = model.content;
    self.twolab.text = model.time;
}

@end
