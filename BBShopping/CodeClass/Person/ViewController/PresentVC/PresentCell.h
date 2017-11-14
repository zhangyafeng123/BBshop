//
//  PresentCell.h
//  BBShopping
//
//  Created by mibo02 on 17/2/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentModel.h"
@interface PresentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (nonatomic, strong)PresentModel *model;







@end
