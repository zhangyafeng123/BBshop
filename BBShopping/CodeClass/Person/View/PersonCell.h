//
//  PersonCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(NSInteger index);
@interface PersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thrdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;

@property (nonatomic, copy)ButtonBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UILabel *bageLabel;
@property (weak, nonatomic) IBOutlet UILabel *bageone;
@property (weak, nonatomic) IBOutlet UILabel *bagetwo;
@property (weak, nonatomic) IBOutlet UILabel *bagethree;

@end
