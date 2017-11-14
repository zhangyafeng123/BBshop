//
//  DetailTimeModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/13.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class subTimeDetailModel;
@interface DetailTimeModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong)NSMutableArray <subTimeDetailModel *>*timeArr;

@end

@interface subTimeDetailModel : NSObject

@property (nonatomic, assign)BOOL selected;
@property (nonatomic, copy)NSString *value;

@end
