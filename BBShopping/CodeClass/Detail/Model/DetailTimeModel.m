//
//  DetailTimeModel.m
//  BBShopping
//
//  Created by mibo02 on 17/2/13.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "DetailTimeModel.h"

@implementation DetailTimeModel
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
    if ([key isEqualToString:@"valueList"]) {
        for (NSDictionary *dic in value) {
            subTimeDetailModel *model = [subTimeDetailModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.timeArr addObject:model];
        }
    }
}
@end

@implementation subTimeDetailModel



@end


