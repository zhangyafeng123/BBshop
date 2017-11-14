//
//  UserInfoManager.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "UserInfoManager.h"

#define KEY @"USERINFO"
/***/
static PersonModel *shareManager = nil;

@implementation UserInfoManager


/**
 *  保存用户信息
 */
+ (void)saveUserInfoWithModel:(PersonModel *)entity{
    /**NSUserDefaults继承与NSObject,单例设计模式,存储信息采用键值对的形式*/
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    /**将实体归档成data数据*/
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:entity];
    /**存数据*/
    [userD setObject:data forKey:KEY];
    /**NSUserDefaults,不是立即写入，写完之后需要同步一下*/
    [userD synchronize];
}

/**
 *  清空用户信息
 */
+ (void)cleanUserInfo{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD removeObjectForKey:KEY];
    [userD synchronize];
    shareManager = nil;
}

/**
 *  获取用户信息
 */
+ (PersonModel *)getUserInfo{
    /**如果之前取过就不在取直接返回,否则从沙盒中查找*/
    if (!shareManager) {
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        /**取出来用户的信息*/
        NSData *data = [userD objectForKey:KEY];
        /**判断以下取出来的有没有值*/
        if (data) {
            shareManager = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        } else {
            shareManager = nil;
        }
    }
    return shareManager;
}

/**
 *  判断用户是否登录
 */
+ (BOOL)isLoading{
    if ([UserInfoManager getUserInfo] == nil) {
        return NO;
    }else{
        return YES;
    }
}


@end
