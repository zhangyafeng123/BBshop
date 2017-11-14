//
//  HomeMoreModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeMoreModel : NSObject
@property (nonatomic, assign)CGFloat factoryPrice;
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, assign)NSInteger salesNum;
@property (nonatomic, assign)NSInteger marketPrice;
@property (nonatomic, assign)NSInteger evaluateNums;
@property (nonatomic, copy)NSString *subTitle;

@end
