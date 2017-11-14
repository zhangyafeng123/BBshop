//
//  Factory.h
//  BBShopping
//
//  Created by mibo02 on 17/1/18.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface Factory : NSObject


+(NSString *)md5String:(NSString *)sourceString;

@end
