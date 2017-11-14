//
//  JJNumberReq.m
//  BBShopping
//
//  Created by mibo02 on 17/2/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "JJNumberReq.h"

@implementation JJNumberReq
+(void)addRequeststoreUserId:(NSInteger)storeUserId storeid:(NSInteger)storeid goodsid:(NSInteger)goodsid  skuid:(NSInteger)skuid
{

    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    //请求
    [PPNetworkHelper POST:increaseCartGoodsURL parameters:@{@"store_user_id":@(storeUserId),@"store_id":@(storeid),@"goods_id":@(goodsid),@"sku_id":@(skuid)} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showError:responseObject[@"message"]];
        } else if ([responseObject[@"code"] integerValue] == 9999){
            [MBProgressHUD showError:@"请登录"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
+(void)minRequeststoreUserId:(NSInteger)storeUserId storeid:(NSInteger)storeid goodsid:(NSInteger)goodsid  skuid:(NSInteger)skuid
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [PPNetworkHelper POST:minusCartGoodsURL parameters:@{@"store_user_id":@(storeUserId),@"store_id":@(storeid),@"goods_id":@(goodsid),@"sku_id":@(skuid)} success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            [MBProgressHUD showError:responseObject[@"message"]];
        }else if ([responseObject[@"code"] integerValue] == 9999){
            [MBProgressHUD showError:@"请登录"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
