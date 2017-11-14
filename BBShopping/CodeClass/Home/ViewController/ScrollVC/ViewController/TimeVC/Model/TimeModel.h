//
//  TimeModel.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubModele;


@interface TimeModel : NSObject

@property (nonatomic, assign)NSInteger id;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, assign)NSInteger seconds;

@property (nonatomic, assign)NSInteger status;

@property (nonatomic, strong)NSMutableArray<SubModele *> *timeArr;

@end


@interface SubModele : NSObject
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)CGFloat discountPrice;
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, assign)CGFloat groupBuyPrice;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, copy)NSString *subTitle;


@end







