//
//  ContentModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/12.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (nonatomic, copy)NSString *headimgurl;
@property (nonatomic, copy)NSString *user;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *addTime;
@property (nonatomic, assign)NSInteger evaluation;
@property (nonatomic, assign)NSInteger rateType;
//回复内容
@property (nonatomic, copy)NSString *replyContent;

@end
