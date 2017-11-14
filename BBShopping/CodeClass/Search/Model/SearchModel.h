//
//  SearchModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/6.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *pic_server_url1;
@property (nonatomic, copy)NSString *sub_title;
@property (nonatomic, strong)NSDictionary *goodsSku;

@end
