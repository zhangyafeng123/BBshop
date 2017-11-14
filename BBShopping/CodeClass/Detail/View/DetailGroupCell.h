//
//  DetailGroupCell.h
//  BBShopping
//
//  Created by mibo02 on 17/2/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailGroupModel.h"
@interface DetailGroupCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)getgroupforModel:(DetailGroupModel *)model;



@end
