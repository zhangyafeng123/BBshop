//
//  AddressModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/20.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy)NSString *address;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, assign)BOOL isReceiveDefault;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *name;

@end
