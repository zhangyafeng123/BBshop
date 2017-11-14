//
//  MyGroupModel.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyGroupsubModel;
@interface MyGroupModel : NSObject
//是否评价
@property (nonatomic, assign)NSInteger israte;
@property (nonatomic, copy)NSString *salesOutlets;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)CGFloat postage;
@property (nonatomic, strong)NSMutableArray <MyGroupsubModel *>*groupArray;
@property (nonatomic, assign)NSInteger grouponStatus;
@property (nonatomic, assign)CGFloat totalPrice;
@property (nonatomic, assign)NSInteger grouponId;
@property (nonatomic, assign)NSInteger orderStatus;
@property (nonatomic, assign)NSInteger activityGoodsLimitId;
@property (nonatomic, copy)NSString *orderno;
@end

@interface MyGroupsubModel : NSObject
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)CGFloat goodsPrice;
@property (nonatomic, copy)NSString *skupropertys;
@property (nonatomic, copy)NSString *goodsPicurl;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *orderNo;

//
@property (nonatomic, copy)NSString *context;
@property (nonatomic, copy)NSString *score;
@end

