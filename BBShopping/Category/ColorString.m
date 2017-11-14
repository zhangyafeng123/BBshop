//
//  ColorString.m
//  PractiseA
//
//  Created by mibo02 on 16/11/22.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "ColorString.h"

@implementation ColorString


+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

// 上传单张图片
+ (void)uploadPOST:(NSString *)url
        parameters:(NSDictionary *)parameters
         consImage:(UIImage *)consImage
           success:(void(^)(id responObject))successBlock
           failure:(void(^)(NSError *error))failureBlock {
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置可接受的数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    [manager.requestSerializer setValue:[UserInfoManager getUserInfo].token forHTTPHeaderField:@"token"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (consImage) {
            //1.转成NSData类型
            NSData *data = UIImageJPEGRepresentation(consImage, 1);
            //2.加时间
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            //转成文件格式
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"file"  fileName:fileName mimeType:@"png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error);
        
    }];
    
}

@end
