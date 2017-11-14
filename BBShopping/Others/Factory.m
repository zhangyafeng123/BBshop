//
//  Factory.m
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "Factory.h"

@implementation Factory


+(NSString *)md5String:(NSString *)sourceString{
    if(!sourceString){
        return nil;
    }

    const char *cString = sourceString.UTF8String;
    //创建一个C语言的字符数组，用来接收加密结束之后的字符
    unsigned char result[CC_MD5_DIGEST_LENGTH];
  
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    
    NSMutableString *resultString = [[NSMutableString alloc]init];
    //遍历所有的result数组，取出所有的字符来拼接
    for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString  appendFormat:@"%02x",result[i]];
       
    }
  
    return resultString;
}


@end
