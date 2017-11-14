//
//  DetailSevenCell.h
//  BBShopping
//
//  Created by mibo02 on 17/2/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentModel.h"
@interface DetailSevenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UIView *StarView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *backContentLab;
@property (nonatomic, strong)ContentModel *model;
@end
