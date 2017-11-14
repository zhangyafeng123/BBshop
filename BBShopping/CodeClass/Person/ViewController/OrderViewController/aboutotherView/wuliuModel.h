//
//  wuliuModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wuliuModel : NSObject
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;

//物流 商品model
@property (nonatomic, copy)NSString *goodsPicUrl;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *skupropertys;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)CGFloat goodsPrice;
@end
