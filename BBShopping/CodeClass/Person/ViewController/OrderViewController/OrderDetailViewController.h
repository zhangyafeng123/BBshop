//
//  OrderDetailViewController.h
//  BBShopping
//
//  Created by mibo02 on 17/3/8.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController
@property (nonatomic, assign)NSInteger  orderId;
//订单的状态
@property (nonatomic, assign)NSInteger orderStatusNew;
//判断是否可以申请
@property (nonatomic, strong)NSMutableArray *canshenqingArr;
@end
