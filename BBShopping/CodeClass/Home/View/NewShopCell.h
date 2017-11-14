//
//  NewShopCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewShopModel.h"
@interface NewShopCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;

@property (nonatomic, strong)NewShopModel *model;

@end
