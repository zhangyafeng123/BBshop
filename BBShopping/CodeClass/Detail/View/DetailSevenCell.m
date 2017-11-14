//
//  DetailSevenCell.m
//  BBShopping
//
//  Created by mibo02 on 17/2/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DetailSevenCell.h"

@implementation DetailSevenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ContentModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.headimgurl]];
    self.nickLab.text = model.user;
    self.contentLab.text = model.content;
    self.dateLab.text = model.addTime;
    self.backContentLab.text = model.replyContent;
}
@end
