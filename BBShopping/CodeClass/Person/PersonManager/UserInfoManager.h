//
//  UserInfoManager.h
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonModel.h"
@interface UserInfoManager : NSObject
/**
 *  保存用户信息
 */
+ (void)saveUserInfoWithModel:(PersonModel *)entity;

/**
 *  清空用户信息
 */
+ (void)cleanUserInfo;

/**
 *  获取用户信息
 */
+ (PersonModel *)getUserInfo;

/**
 *  判断用户是否登录
 */
+ (BOOL)isLoading;
@end
