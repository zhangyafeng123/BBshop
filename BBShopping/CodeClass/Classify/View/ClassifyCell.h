//
//  ClassifyCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassSortModel.h"
@interface ClassifyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property (nonatomic, strong)ClassSortModel *model;

@end
