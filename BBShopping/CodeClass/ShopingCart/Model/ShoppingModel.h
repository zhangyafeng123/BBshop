//
//  ShoppingModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingModel : NSObject
//单个商品被选中
@property (nonatomic, assign)BOOL isSelect;

@property (nonatomic, assign)NSInteger buycount;
@property (nonatomic, assign)CGFloat exFactoryPrice;
@property (nonatomic, assign)NSInteger fhUserId;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)CGFloat groupBuyPrice;
@property (nonatomic, assign)CGFloat groupBuyPriceDot;
@property (nonatomic, assign)NSInteger groupBuyPriceNum;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *logisticscompany;
@property (nonatomic, assign)NSInteger onedistributorcommission;
@property (nonatomic, assign)NSInteger onedistributorcompany;
@property (nonatomic, assign)NSInteger onedistributorpercent;
@property (nonatomic, copy)NSString *picServerUrl1;
@property (nonatomic, assign)NSInteger platformcommission;
@property (nonatomic, assign)NSInteger platformcompany;
@property (nonatomic, assign)NSInteger platformpercent;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)NSInteger salesNum;
@property (nonatomic, assign)NSInteger shopMarketPrice;
@property (nonatomic, assign)NSInteger skuId;
@property (nonatomic, assign)NSInteger storeId;
@property (nonatomic, assign)NSInteger storeUserId;
@property (nonatomic, assign)NSInteger taketype;
@property (nonatomic, assign)NSInteger threedistributorcommission;
@property (nonatomic, assign)NSInteger threedistributorcompany;
@property (nonatomic, assign)NSInteger threedistributorpercent;
@property (nonatomic, copy)NSString *totalPrice;
@property (nonatomic, assign)NSInteger twodistributorcommission;
@property (nonatomic, assign)NSInteger twodistributorcompany;
@property (nonatomic, assign)NSInteger twodistributorpercent;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, assign)NSInteger userType;
@property (nonatomic, assign)NSInteger weight;
@property (nonatomic, copy)NSString *storeName;
@property (nonatomic, assign)NSInteger status;
@end
