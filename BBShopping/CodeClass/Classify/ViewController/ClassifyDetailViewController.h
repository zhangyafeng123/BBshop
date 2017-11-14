//
//  ClassifyDetailViewController.h
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"
#import "ClassSortModel.h"

//排序 0综合排序 1按价格升序排序 2按价格降序排序 3按销售降序排序 4按评价降序排序 5按最新上架时间降序排序
//typedef NS_OPTIONS(NSInteger, NumberTypeActiones){
//    ActionTypeOne = 0,
//    ActionTypeTwo = 1,
//    ActionTypeThree = 2,
//    ActionTypeFour = 3,
//    ActionTypeFive = 4,
//    ActionTypeSix  = 5
//};

@interface ClassifyDetailViewController : BaseViewController


//标识（首页更多进入，广告图进入，分类进入）
@property (nonatomic, assign)NSInteger newtypeid;


//首页进入
@property (nonatomic, assign)NSInteger homeMoreindex;

//分类页进入
@property (nonatomic, strong)ClassSortModel *sortModel;

//首页广告图点击进入
//@property (nonatomic, assign)NSInteger homeadsID;
@property (nonatomic, copy)NSString *adsTitle;



@end
