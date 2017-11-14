//
//  AddressRequest.m
//  BBShopping
//
//  Created by mibo02 on 17/2/22.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "AddressRequest.h"
#import "AddressModel.h"
@implementation AddressRequest


+ (void)requestList:(UITableView *)tableV arr:(NSMutableArray *)arr
{
    
    if ([UserInfoManager isLoading]) {
        [PPNetworkHelper GET:getAddressListURL parameters:@{} success:^(id responseObject) {
            [arr removeAllObjects];
            if ([responseObject[@"code"] integerValue] == 0) {
                for (NSDictionary *dic in responseObject[@"map"][@"addressList"]) {
                    AddressModel *model = [AddressModel new];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr addObject:model];
                }
                if (arr == 0) {
                    [tableV reloadEmptyDataSet];
                }
            }
            [tableV reloadData];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [tableV reloadEmptyDataSet];
        [MBProgressHUD showError:@"请登录"];
    }
    
}

@end
