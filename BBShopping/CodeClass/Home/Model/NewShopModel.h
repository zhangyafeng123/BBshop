//
//  NewShopModel.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewShopModel : NSObject
//banner
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *reqUrl;
//数据
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger id;

@property (nonatomic, copy)NSString *descption;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, assign)CGFloat groupBuyPrice;
@property (nonatomic, copy)NSString *subTitle;

@end
