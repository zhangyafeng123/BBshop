//
//  ChosenModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/4.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChosenModel : NSObject

@property (nonatomic, assign)NSInteger goodsId;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *goodsUrl;
@property (nonatomic, assign)CGFloat groupBuyPrice;
@property (nonatomic, copy)NSString *subTitle;

@end
