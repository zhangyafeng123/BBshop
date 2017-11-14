//
//  PresentModel.h
//  BBShopping
//
//  Created by mibo02 on 17/2/19.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentModel : NSObject

@property (nonatomic, copy)NSString *cardNo;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *cardTime;
@property (nonatomic, assign)NSInteger id;
@property (nonatomic, copy)NSString *cardCountType;
@property (nonatomic, assign)CGFloat cardBalance;
@property (nonatomic, assign)NSInteger faceValue;

@end
