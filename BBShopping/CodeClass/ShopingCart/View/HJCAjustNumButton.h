//
//  HJCAjustNumButton.h
//  HJCAdjustButtonTest
//
//  Created by HJaycee on 15/6/4.
//  Copyright (c) 2015年 HJaycee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HJCAjustNumButtonDelegate <NSObject>

- (void)clickButtonAction:(UIButton *)sender;

@end


@interface HJCAjustNumButton : UIView

@property (nonatomic, assign)id<HJCAjustNumButtonDelegate>delegate;
//


/**
 *  边框颜色，默认值是浅灰色
 */
@property (nonatomic, assign) UIColor *lineColor;

/**
 *  文本框内容
 */
@property (nonatomic, copy) NSString *currentNum;

/**
 *  文本框内容改变后的回调
 */
@property (nonatomic, copy) void (^callBack) (NSString *currentNum);



@end
