//
//  orderAllModel.m
//  BBShopping
//
//  Created by mibo02 on 17/3/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "orderAllModel.h"

@implementation orderAllModel
- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.listArray  = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"frontOrderGoodsView"]) {
        for (NSDictionary *dic in value) {
            if (dic) {
                orderSubModel *model = [orderSubModel new];
                [model setValuesForKeysWithDictionary:dic];
                [self.listArray addObject:model];
            }
            
        }
    }
}

@end

@implementation orderSubModel



@end


