//
//  jiesuanModel.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/24.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "jiesuanModel.h"

@implementation jiesuanModel


- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.listArray = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"postageTemplateList"]) {
        for (NSDictionary *dic in value) {
            jiesuanListModel *model = [jiesuanListModel new];
            [model setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
        }
    }
}

@end

@implementation jiesuanListModel

- (instancetype)init
{
    self  = [super init];
    if (self) {
        self.storeArray  = [NSMutableArray new];
        self.takeTypeArray = [NSMutableArray new];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"takeTypeList"]) {
        for (NSDictionary *dic in value) {
            
            jiesuantakeTypeModel *takemodel = [jiesuantakeTypeModel new];
            [takemodel setValuesForKeysWithDictionary:dic];
            [self.takeTypeArray addObject:takemodel];
            
        }
 
    }
    if ([key isEqualToString:@"goodsList"]) {
        for (NSDictionary *storDic in value) {
            jiesuanSubModel *model  =[jiesuanSubModel new];
            [model setValuesForKeysWithDictionary:storDic];
            [self.storeArray addObject:model];
        }
    }
    
    
}

@end



@implementation jiesuanSubModel



@end

@implementation jiesuantakeTypeModel



@end










