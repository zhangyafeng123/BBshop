//
//  PersonModel.m
//  BBShopping
//
//  Created by mibo02 on 17/1/21.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _userId = [aDecoder decodeIntegerForKey:@"userId"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _mobile = [aDecoder decodeObjectForKey:@"mobile"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _headimgurl = [aDecoder decodeObjectForKey:@"headimgurl"];
        _token = [aDecoder decodeObjectForKey:@"token"];
       
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_userId forKey:@"userId"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_headimgurl forKey:@"headimgurl"];
    [aCoder encodeObject:_token forKey:@"token"];
   
}

@end
