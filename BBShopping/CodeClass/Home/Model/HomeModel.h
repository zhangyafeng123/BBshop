//
//  HomeModel.h
//  BBShopping
//
//  Created by mibo02 on 17/1/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SubModel;
@interface HomeModel : NSObject

//轮播图
@property (nonatomic, copy)NSString *adpic;
@property (nonatomic, copy)NSString *appAdUrl;
@property (nonatomic, assign)NSInteger appUrlId;
@property (nonatomic, assign)NSInteger appUrlType;

//shortAdList：导航广告集合

//hotTitle：热推商品标题，如时节之味
@property (nonatomic, copy)NSString *addtime;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger datatype;
@property (nonatomic, assign)NSInteger showHide;
@property (nonatomic, assign)NSInteger position;
@property (nonatomic, assign)NSInteger wxmallId;

//hotGoodsList：热推商品集合
@property (nonatomic, copy)NSString *descption;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *subTitle;
//showNewAd
@property (nonatomic, assign)NSInteger showNewAd;

// storeyDataList：楼层集合
@property (nonatomic, copy)NSString *morePic;
@property (nonatomic, copy)NSString *storeyName;

// detailList：楼层广告集合

//  goodsList
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, copy)NSString *price;

@property (nonatomic, strong)NSMutableArray<SubModel *> *GoodsListArray;

@end

@interface SubModel : NSObject

@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, copy)NSString *subTitle;

@end




