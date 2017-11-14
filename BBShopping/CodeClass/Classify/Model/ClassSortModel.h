//
//  ClassSortModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassSortModel : NSObject

@property (nonatomic, assign)NSInteger app_id;
@property (nonatomic, assign)NSInteger cateLevel;
@property (nonatomic, copy)NSString *cateName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)BOOL isSpericalCate;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *mainPic;
@property (nonatomic, assign)NSInteger orderId;
@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, assign)BOOL whetherParent;


@end
