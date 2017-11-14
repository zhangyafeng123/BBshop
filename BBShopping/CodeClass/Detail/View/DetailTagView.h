//
//  DetailTagView.h
//  BBShopping
//
//  Created by mibo02 on 17/2/9.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetailTagViewDelegate <NSObject>
//标签按钮点击事件
- (void)buttonClickAction:(NSString *)btnStr;

@end
@interface DetailTagView : UIView

@property (nonatomic, assign)id<DetailTagViewDelegate>delegegate;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray *)array;

@end
