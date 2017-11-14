//
//  pinglunModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pinglunModel : NSObject
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)NSInteger evaluation;
@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *goodsPicUrl;
@property (nonatomic, assign)CGFloat goodsPrice;
@property (nonatomic, assign)NSInteger rateAspect;
@property (nonatomic, assign)NSInteger rateType;
@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, copy)NSString *userName;




@end
