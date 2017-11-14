//
//  GroupModel.h
//  BBShopping
//
//  Created by mibo02 on 17/1/17.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

//轮播图URL
@property (nonatomic, copy)NSString *url;
//拼团价
@property (nonatomic, assign)CGFloat  discountPrice;
//单买价
@property (nonatomic, assign)CGFloat groupBuyPrice;
//名称
@property (nonatomic, copy)NSString *goodsName;
//id
@property (nonatomic, assign)NSInteger id;
//图片
@property (nonatomic, copy)NSString *picServerUrl1;
//小标题
@property (nonatomic, copy)NSString *subTitle;



@end
