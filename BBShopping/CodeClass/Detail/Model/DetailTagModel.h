//
//  DetailTagModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/11.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailTagModel : NSObject
@property (nonatomic, assign)CGFloat exFactoryPrice;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, assign)CGFloat groupBuyPrice;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)BOOL isRecommend;
@property (nonatomic, assign)BOOL isSku;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)NSInteger salesNum;
@property (nonatomic, assign)CGFloat shopMarketPrice;
@property (nonatomic, copy)NSString *sku1Name;
@property (nonatomic, copy)NSString *sku1Value;
@property (nonatomic, copy)NSString *sku2Name;
@property (nonatomic, copy)NSString *sku2Value;
@property (nonatomic, assign)NSInteger status;
@end
