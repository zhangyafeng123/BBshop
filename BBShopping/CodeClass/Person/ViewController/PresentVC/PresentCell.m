//
//  PresentCell.m
//  BBShopping
//
//  Created by mibo02 on 17/2/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PresentCell.h"

@implementation PresentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(PresentModel *)model
{
    
    self.firstLab.text = [NSString stringWithFormat:@"礼品卡号 : %@",model.cardNo];
    self.secLab.text = model.status;
    if ([model.status isEqualToString:@"已激活"]) {
        self.secLab.textColor = [ColorString colorWithHexString:@"#f9cd02"];
        self.backView.backgroundColor = [ColorString colorWithHexString:@"#f9cd02"];
    } else {
         self.secLab.textColor = [UIColor blackColor];
        self.backView.backgroundColor = [UIColor lightGrayColor];
    }
    self.priceLab.text = [NSString stringWithFormat:@"面值 : %ld元",model.faceValue];
    self.dateLab.text = [NSString stringWithFormat:@"有效期限 : %@ %@",model.cardTime,model.cardCountType];
}

@end
