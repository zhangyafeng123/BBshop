//
//  UIView+Animation.h
//  BBShopping
//
//  Created by 张亚峰 on 2017/2/26.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
- (void)animationStartPoint:(CGPoint)start endPoint:(CGPoint)end didStopAnimation:(void(^)(void)) event;
@end
