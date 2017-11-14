//
//  waitshouhuoCell.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/23.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderAllModel.h"
#import "orderDetailModel.h"
#import "MyGroupModel.h"
#import "wuliuModel.h"
@interface waitshouhuoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shouhouButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *guigeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (nonatomic, strong)MyGroupsubModel *groupmodel;
@property (nonatomic, strong)orderSubModel *model;
@property (nonatomic, strong)orderDetailModel *detailModel;
@property (nonatomic, strong)wuliuModel *wuliuModel;
@end
