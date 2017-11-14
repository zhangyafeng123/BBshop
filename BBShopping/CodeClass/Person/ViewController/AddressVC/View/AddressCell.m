//
//  AddressCell.m
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(AddressModel *)model
{
    self.nameLab.text = model.name;
    self.addressLab.text = model.address;
    self.phoneLab.text = model.mobile;
}

@end
