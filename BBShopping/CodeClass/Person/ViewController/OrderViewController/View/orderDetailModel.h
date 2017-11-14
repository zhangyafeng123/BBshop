//
//  orderDetailModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderDetailModel : NSObject

@property (nonatomic, assign)CGFloat totalPrice;
@property (nonatomic, assign)NSInteger twoDistributorCompany;
@property (nonatomic, assign)NSInteger  threeDistributorCompany;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)NSInteger skuId;
@property (nonatomic, assign)CGFloat goodsPrice;
@property (nonatomic, assign)NSInteger platformCommission;
@property (nonatomic, assign)NSInteger goodsPackId;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, assign)NSInteger platformCompany;
@property (nonatomic, assign)NSInteger oneDistributorCommission;
@property (nonatomic, assign)NSInteger platformPercent;
@property (nonatomic, assign)NSInteger oneDistributorCompany;
@property (nonatomic, assign)NSInteger threeDistributorPercent;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)CGFloat exFactoryPrice;
@property (nonatomic, copy)NSString *orderNo;
@property (nonatomic, assign)NSInteger twoDistributorPercent;
@property (nonatomic, assign)NSInteger threeDistributorCommission;
@property (nonatomic, assign)NSInteger twoDistributorCommission;
@property (nonatomic, assign)CGFloat preferentialPrice;
@property (nonatomic, assign)CGFloat realPayment;
@property (nonatomic, copy)NSString *goodsPicurl;
@property (nonatomic, assign)NSInteger oneDistributorPercent;

//
@property (nonatomic, copy)NSString *context;
@property (nonatomic, copy)NSString *score;

//@property (nonatomic, assign)BOOL isApplyAfterSale;



@end
