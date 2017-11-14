//
//  orderAllModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class orderSubModel;
@interface orderAllModel : NSObject

@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)NSInteger xsStoreId;
@property (nonatomic, assign)BOOL israte;
@property (nonatomic, copy)NSString *orderno;
@property (nonatomic, assign)NSInteger payStyle;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, assign)NSInteger grouponStatus;
@property (nonatomic, assign)NSInteger orderStatus;
@property (nonatomic, assign)CGFloat realPayment;
@property (nonatomic, assign)CGFloat postage;
@property (nonatomic, assign)CGFloat totalPrice;
@property (nonatomic, assign)NSInteger logisticsType;
@property (nonatomic, assign)NSInteger takeType;
@property (nonatomic, copy)NSString *salesOutlets;
@property (nonatomic, strong)NSMutableArray <orderSubModel *>*listArray;
@property (nonatomic, assign)BOOL priceModifyStatus;

@end

@interface orderSubModel : NSObject
@property (nonatomic, copy)NSString *orderNo;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)CGFloat goodsPrice;
@property (nonatomic, copy)NSString *goodsPicurl;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *skupropertys;
@property (nonatomic, assign)BOOL isApplyAfterSale;

@property (nonatomic, copy)NSString *context;
@property (nonatomic, copy)NSString *score;


@end


