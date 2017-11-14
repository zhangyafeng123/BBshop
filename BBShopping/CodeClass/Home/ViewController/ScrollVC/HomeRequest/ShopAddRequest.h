//
//  ShopAddRequest.h
//  BBShopping
//
//  Created by mibo02 on 17/2/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAddRequest : NSObject

+ (void)requestForShop:(NSInteger )shopID   buycount:(NSString *)buycount   enterperson:(void(^)(void))enterperson;
//加入购物车请求
+ (void)addShopIngRequest:(NSDictionary *)newdic buycount:(NSString *)numberstr;
@end
