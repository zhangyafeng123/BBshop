//
//  ClassDetailModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/10.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassDetailModel : NSObject

@property (nonatomic, assign)NSInteger category_id;
@property (nonatomic, assign)NSInteger evaluate_num;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, strong)NSDictionary *goodsSku;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *pic_server_url1;
@property (nonatomic, copy)NSString *sub_title;
@property (nonatomic, assign)NSInteger supplier_id;

@end
