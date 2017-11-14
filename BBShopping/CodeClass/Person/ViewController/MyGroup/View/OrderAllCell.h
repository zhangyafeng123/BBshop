//
//  OrderAllCell.h
//  BBShopping
//
//  Created by mibo02 on 17/3/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGroupModel.h"
@interface OrderAllCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong)MyGroupsubModel *groupmodel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@end
