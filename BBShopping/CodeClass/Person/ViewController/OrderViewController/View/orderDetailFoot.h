//
//  orderDetailFoot.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderDetailFoot : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UILabel *fiveLab;

@property (weak, nonatomic) IBOutlet UILabel *topfirstLab;
@property (weak, nonatomic) IBOutlet UILabel *topsecondLab;
@property (weak, nonatomic) IBOutlet UILabel *topthreeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtninset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightinset;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeinset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourinset;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fiveinset;


@property (weak, nonatomic) IBOutlet UIButton *pingjiaButton;





@end
