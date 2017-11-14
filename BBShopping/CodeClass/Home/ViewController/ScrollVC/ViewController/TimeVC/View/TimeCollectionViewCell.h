//
//  TimeCollectionViewCell.h
//  BBShopping
//
//  Created by mibo02 on 17/2/5.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"
@interface TimeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *subpriceLab;

@property (nonatomic, strong)SubModele *subModel;
@property (weak, nonatomic) IBOutlet UIView *buyButton;



@end
