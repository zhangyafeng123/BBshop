//
//  getpersonInfoRequest.m
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "getpersonInfoRequest.h"


@implementation getpersonInfoRequest

+ (NSMutableArray *)requestforPersonaddressid:(NSInteger)addressid
{
    NSMutableArray *arr = [NSMutableArray new];
    [arr removeAllObjects];
      [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper GET:[NSString stringWithFormat:@"%@?id=%ld",getAddressURL,addressid] parameters:@{} success:^(id responseObject) {
        for (NSDictionary *shengdic in responseObject[@"map"][@"provinceList"]) {
            if ([shengdic[@"selected"] integerValue] == 1) {
                [arr addObject:shengdic[@"value"]];
            }
            for (NSDictionary *shidic in responseObject[@"map"][@"cityList"]) {
                if ([shidic[@"selected"] integerValue] == 1) {
                    [arr addObject:shidic[@"value"]];
                }
            }
            
            for (NSDictionary *qudic in responseObject[@"map"][@"districtList"]) {
                if ([qudic[@"selected"] integerValue] == 1) {
                    [arr addObject:qudic[@"value"]];
                }
            }
            [arr addObject:responseObject[@"map"][@"address"]];
        }
        
    //    NSLog(@"个数:%ld",arr.count);
        
    } failure:^(NSError *error) {
        
    }];
    
 //   NSLog(@"%ld",arr.count);
    
    return arr;
    
}

@end
