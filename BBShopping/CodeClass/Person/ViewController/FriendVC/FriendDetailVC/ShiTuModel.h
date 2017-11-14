//
//  ShiTuModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/6.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShiTuModel : NSObject

@property (nonatomic, copy)NSString *user_name;
@property (nonatomic, assign)NSInteger pro_type;
@property (nonatomic, assign)CGFloat pro_totalPrice;
@property (nonatomic, assign)CGFloat pro_devotePrice;
@property (nonatomic, copy)NSString *last_time;
@property (nonatomic, assign)NSInteger pro_user_id;

@end
