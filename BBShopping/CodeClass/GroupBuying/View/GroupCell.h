//
//  GroupCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupModel;
@interface GroupCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *threedLab;
@property (weak, nonatomic) IBOutlet UILabel *fourdLab;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic, strong)GroupModel *model;

@end
