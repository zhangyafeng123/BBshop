//
//  ChosenCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChosenModel.h"
@interface ChosenCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@property (nonatomic, strong)ChosenModel *model;


@end
