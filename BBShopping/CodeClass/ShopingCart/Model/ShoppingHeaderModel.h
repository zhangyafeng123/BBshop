//
//  ShoppingHeaderModel.h
//  BBShopping
//
//  Created by mibo02 on 17/3/14.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingHeaderModel : NSObject
@property (nonatomic, assign)NSInteger store_user_id;
@property (nonatomic, assign)NSInteger store_id;
@property (nonatomic, copy)NSString *store_name;
@property (nonatomic, strong)NSMutableArray *goodsCarts;
//店铺被选中
@property (nonatomic, assign)BOOL isSelect;//

@end
