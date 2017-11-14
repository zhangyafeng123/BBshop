//
//  ThridCell.h
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "SearchModel.h"
#import "ClassDetailModel.h"
#import "HomeMoreModel.h"
@class ThridCell;

//购买按钮点击代理方法
@protocol ThridCellbuyBtnDelegate <NSObject>

- (void)buyBtnAction:(ThridCell *)cell;

@end



@interface ThridCell : UICollectionViewCell


@property (nonatomic, assign)id<ThridCellbuyBtnDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *BigImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (nonatomic, strong)SubModel *model;
//搜索model
@property (nonatomic, strong)SearchModel *searchModel;
@property (nonatomic, strong)ClassDetailModel *detailModel;
@property (nonatomic, strong)HomeMoreModel * moreModel;


@end
