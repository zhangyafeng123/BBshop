//
//  PersonCell.m
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [PriceLine initButton:_firstBtn];
    [PriceLine initButton:_secondBtn];
    [PriceLine initButton:_thrdBtn];
    [PriceLine initButton:_fourBtn];
    
}


- (IBAction)waitButtonAction:(UIButton *)sender {
    self.buttonBlock(sender.tag);
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
