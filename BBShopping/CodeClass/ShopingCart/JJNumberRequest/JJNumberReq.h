//
//  JJNumberReq.h
//  BBShopping
//
//  Created by mibo02 on 17/2/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNumberReq : NSObject
//+
+(void)addRequeststoreUserId:(NSInteger)storeUserId storeid:(NSInteger)storeid goodsid:(NSInteger)goodsid  skuid:(NSInteger)skuid;
//-
+(void)minRequeststoreUserId:(NSInteger)storeUserId storeid:(NSInteger)storeid goodsid:(NSInteger)goodsid  skuid:(NSInteger)skuid;
@end
