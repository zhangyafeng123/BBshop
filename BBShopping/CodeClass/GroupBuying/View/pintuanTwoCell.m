//
//  pintuanTwoCell.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "pintuanTwoCell.h"

@implementation pintuanTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(pintuanModel *)model
{
    [self.lastImg sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    if (model.whetherHead == 1) {
        
        self.titlelab.text = [NSString stringWithFormat:@"团长%@%@开团",model.nickName,model.createTime];
    } else {
        self.titlelab.text = [NSString stringWithFormat:@"团员%@%@开团",model.nickName,model.createTime];
    }
    
    
    
}
@end
