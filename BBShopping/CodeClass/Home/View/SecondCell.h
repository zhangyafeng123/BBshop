//
//  SecondCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface SecondCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;
@property (weak, nonatomic) IBOutlet UILabel *oneLab;
@property (weak, nonatomic) IBOutlet UILabel *twolab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (nonatomic, strong)HomeModel *model;


@end
