//
//  PersonModel.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSCoding>

@property (nonatomic, assign)NSInteger  userId;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *nickname;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *headimgurl;
@property (nonatomic, copy)NSString *token;

@end
