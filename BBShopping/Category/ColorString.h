//
//  ColorString.h
//  PractiseA
//
//  Created by mibo02 on 16/11/22.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorString : NSObject

+(UIColor *) colorWithHexString: (NSString *)color;
+ (void)uploadPOST:(NSString *)url
        parameters:(NSDictionary *)parameters
         consImage:(UIImage *)consImage
           success:(void(^)(id responObject))successBlock
           failure:(void(^)(NSError *error))failureBlock;


@end
