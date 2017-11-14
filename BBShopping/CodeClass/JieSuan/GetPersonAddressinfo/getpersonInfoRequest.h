//
//  getpersonInfoRequest.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/25.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getpersonInfoRequest : NSObject

//过去个人地址信息
+ (NSMutableArray *)requestforPersonaddressid:(NSInteger)addressid;


@end
