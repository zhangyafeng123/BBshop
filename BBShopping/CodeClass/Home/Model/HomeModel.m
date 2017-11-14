//
//  HomeModel.m
//  BBShopping
//
//  Created by mibo02 on 17/1/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.GoodsListArray  = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"goodsList"]) {
        for (NSDictionary *dic in value) {
            SubModel *model = [SubModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.GoodsListArray addObject:model];
        }
    }
}


@end
@implementation SubModel



@end
