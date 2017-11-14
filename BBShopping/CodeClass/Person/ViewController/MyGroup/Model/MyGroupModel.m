//
//  MyGroupModel.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "MyGroupModel.h"

@implementation MyGroupModel
- (instancetype)init
{
    if (self) {
        self.groupArray = [NSMutableArray new];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"frontOrderGoodsView"]) {
        for (NSDictionary *dic in value) {
            MyGroupsubModel *model = [MyGroupsubModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.groupArray addObject:model];
        }
    }
}
@end

@implementation MyGroupsubModel



@end

