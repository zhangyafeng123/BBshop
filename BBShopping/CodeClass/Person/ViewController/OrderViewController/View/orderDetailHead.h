//
//  orderDetailHead.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailHead : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secLab;
@property (weak, nonatomic) IBOutlet UILabel *threelab;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UILabel *fiveLab;
@property (weak, nonatomic) IBOutlet UILabel *sixLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintInset;

@end
