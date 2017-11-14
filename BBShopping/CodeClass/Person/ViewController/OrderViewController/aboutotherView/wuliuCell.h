//
//  wuliuCell.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wuliuModel.h"
@interface wuliuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTopLab;
@property (weak, nonatomic) IBOutlet UILabel *leftLab;

@property (weak, nonatomic) IBOutlet UILabel *onelab;
@property (weak, nonatomic) IBOutlet UILabel *twolab;

@property (nonatomic, strong)wuliuModel *model;

@end
