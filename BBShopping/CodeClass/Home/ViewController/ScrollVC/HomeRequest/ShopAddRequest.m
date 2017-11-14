//
//  ShopAddRequest.m
//  BBShopping
//
//  Created by mibo02 on 17/2/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "ShopAddRequest.h"

@implementation ShopAddRequest
+ (void)requestForShop:(NSInteger )shopID   buycount:(NSString *)buycount   enterperson:(void(^)(void))enterperson
{
    if ([UserInfoManager isLoading]) {
        [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
        NSString *url = [NSString stringWithFormat:@"%@?goodsId=%ld",cartGoodsDetailURL,shopID];
        
        [PPNetworkHelper GET:url parameters:@{} responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            
            if ([responseObject[@"code"] integerValue] == 0) {
                
                if ([responseObject[@"map"][@"quantity"] integerValue] == 0) {
                    [MBProgressHUD showError:@"库存不足"];
                    return;
                } else {
                NSDictionary *newdic = responseObject[@"map"];
                [ShopAddRequest addShopIngRequest:newdic buycount:buycount];
                }
            } else if ([responseObject[@"code"] integerValue]== 9999){
                [MBProgressHUD showError:@"未登录"];
                enterperson();
            }
            
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showError:@"请登录"];
         enterperson();
    }
    
}
//加入购物车请求
+ (void)addShopIngRequest:(NSDictionary *)newdic buycount:(NSString *)numberstr
{
    [PPNetworkHelper setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    //请求成功之后请求加入购物车接口
    NSDictionary *dic = @{@"store_user_id":[NSString stringWithFormat:@"%ld",[newdic[@"store_user_id"] integerValue]],@"store_id":[NSString stringWithFormat:@"%ld",[newdic[@"store_id"] integerValue]],@"goods_id":[NSString stringWithFormat:@"%ld",[newdic[@"goods_id"] integerValue]],@"sku_id":[NSString stringWithFormat:@"%ld",[newdic[@"sku_id"] integerValue]],@"goodsName":newdic[@"goodsName"],@"fh_user_id":[NSString stringWithFormat:@"%ld",[newdic[@"fh_user_id"] integerValue]],@"group_buy_price":[NSString stringWithFormat:@"%.2f",[newdic[@"group_buy_price"] floatValue]],@"shop_market_price":[NSString stringWithFormat:@"%.2f",[newdic[@"shop_market_price"] floatValue]],@"ex_factory_price":[NSString stringWithFormat:@"%.2f",[newdic[@"ex_factory_price"] floatValue]],@"quantity":[NSString stringWithFormat:@"%ld",[newdic[@"quantity"] integerValue]],@"buyCount":numberstr,@"userType":[NSString stringWithFormat:@"%ld",[newdic[@"userType"] integerValue]],@"pic_server_url1":newdic[@"pic_server_url1"],@"store_name":newdic[@"store_name"]};

    [PPNetworkHelper POST:addGoodsToCartURL parameters:dic success:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 0) {
            
            [MBProgressHUD showError:@"加入购物车成功"];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
@end
