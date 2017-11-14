//
//  TimeModel.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/7.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.timeArr  = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"goodsList"]) {
        for (NSDictionary *dic in value) {
            SubModele *model = [SubModele new];
            [model setValuesForKeysWithDictionary:dic];
            [self.timeArr addObject:model];
        }
    }
}

@end

@implementation SubModele

@end;
