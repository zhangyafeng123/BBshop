//
//  NSString+Category.m
//  jiaotong
//
//  Created by xiangguohe on 16/6/20.
//  Copyright © 2016年 XGH. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Category)

/** 是否是手机号 */
- (BOOL)isMobileNumber {

    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170

    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];

    return [regextestmobile evaluateWithObject:self];
    
}

/** 是否是正数或0 */
- (BOOL)isPositiveOrZeroNumber {
    NSString *positiveNumber = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|^[1-9]\\d*|0$";
    NSPredicate *regextestNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positiveNumber];

    return [regextestNumber evaluateWithObject:self];
}

/** 是否是正数 */
- (BOOL)isPositiveNumber {

    NSString *positiveNumber = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*|^[1-9]\\d*$";
    NSPredicate *regextestNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", positiveNumber];

    return [regextestNumber evaluateWithObject:self];

}

/** MD5加密 */
- (NSString *)md5String {

    // 1. 把OC的字符串转化为C语言的字符串(MD5加密是基于C语言实现 Foundation框架字符串需要转化)
    const char * cString = self.UTF8String;
    // 2. 创建字符串数组接收MD5值
    // 一个字节是8位， 两个字节是16位， 两个字符可以表示一个16位进制的数， MD5结果为32位， 实际上由16位16进制数组成
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 3. 计算MD5值（结果存储在result数组中）
    // 参数：（1）C语言字符串，（2）计算字符串长度，（3）数组的首地址，用来接收加密后的值
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    // 4. 获取摘要值
    NSMutableString *bar = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [bar appendFormat:@"%02X", result[i]];
    }
    return bar;
}


//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
