//
//  jiesuanModel.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class jiesuanSubModel, jiesuantakeTypeModel,jiesuanListModel;
@interface jiesuanModel : NSObject
//一家店铺的model
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)CGFloat storeTotalMoney;
@property (nonatomic, strong)NSMutableArray <jiesuanListModel *>*listArray;

@end

//

@interface jiesuanListModel : NSObject
@property (nonatomic, assign)CGFloat goodsTotal;
@property (nonatomic, assign)CGFloat postage;
@property (nonatomic, copy)NSString *logisticsCompany;
@property (nonatomic, assign)NSInteger takeTypeId;
@property (nonatomic, assign)CGFloat postageTotal;

@property (nonatomic, strong)NSMutableArray <jiesuanSubModel *>*storeArray;

@property (nonatomic, strong)NSMutableArray <jiesuantakeTypeModel *>*takeTypeArray;

@end

//商品
@interface jiesuanSubModel : NSObject
@property (nonatomic, copy)NSString *picServerUrl1;
@property (nonatomic ,copy)NSString *goodsName;
@property (nonatomic, copy)NSString *sku;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, assign)NSInteger buyCount;

@property (nonatomic, copy)NSString *groupBuyPrice;

@property (nonatomic, copy)NSString *grouponId;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, assign)NSInteger skuId;
@property (nonatomic, copy)NSString *seckillId;

@end
//物流
@interface jiesuantakeTypeModel : NSObject

@property (nonatomic, assign)NSInteger takeTypeId;
@property (nonatomic, copy)NSString *logisticsCompany;
@property (nonatomic, assign)BOOL selected;

@end
