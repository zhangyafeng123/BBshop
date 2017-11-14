//
//  pintuanTwoCell.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pintuanModel.h"
@interface pintuanTwoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lastImg;

@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (nonatomic, strong)pintuanModel *model;
@end
